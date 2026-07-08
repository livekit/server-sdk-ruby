# frozen_string_literal: true

require 'faraday'
require 'json'
require 'set'
require 'uri'
require 'livekit/utils'
require 'livekit/version'

module LiveKit
  # Region failover for the Twirp API clients.
  #
  # On a retryable failure (any transport error or HTTP 5xx) the client
  # discovers alternative LiveKit Cloud regions via /settings/regions and
  # replays the request against the next region, with exponential backoff. 4xx
  # responses are returned immediately.
  #
  # The +failover+ argument accepted by the service clients is a boolean
  # (default true). When enabled, failover engages for LiveKit Cloud hosts only.
  # The total attempt count and backoff are fixed (not user-configurable) so
  # retries can't be tuned to values that could overwhelm the server.
  module Failover
    MAX_ATTEMPTS = 3
    BACKOFF_BASE = 0.2
    # Default per-request timeout (seconds). Calls that dial a phone override it
    # via TIMEOUT_HEADER (see SIPServiceClient).
    DEFAULT_TIMEOUT = 10
    # Below this per-request timeout a retry is unlikely to help and many clients
    # would retry in lockstep across regions, so a short request gets a single
    # attempt (thundering-herd guard).
    MIN_FAILOVER_TIMEOUT = 5
    # Internal header carrying a per-request timeout override (seconds). Consumed
    # by the middleware and not sent to the server.
    TIMEOUT_HEADER = 'X-Lk-Request-Timeout'

    # Total request attempts including the initial one; 1 means no failover.
    # Failover only engages when enabled, the host is a LiveKit Cloud domain, and
    # the request timeout is long enough to retry. +force+ bypasses the
    # cloud-host check and is for internal testing only.
    def self.attempts(enabled, host, force, timeout)
      return 1 unless enabled && (force || cloud?(host))
      return 1 if timeout && timeout < MIN_FAILOVER_TIMEOUT

      MAX_ATTEMPTS
    end

    # Builds a Faraday connection wired with the region-failover middleware and
    # the LiveKit Twirp base URL. Passed to Twirp::Client in place of a URL.
    def self.connection(base_url, failover)
      url = File.join(Utils.to_http_url(base_url), '/twirp')
      Faraday.new(url: url) do |f|
        f.headers['User-Agent'] = "livekit-server-sdk-ruby/#{VERSION}"
        f.options.timeout = DEFAULT_TIMEOUT
        f.use RegionFailoverMiddleware, failover: failover
        f.adapter Faraday.default_adapter
      end
    end

    # Failover only engages for LiveKit Cloud project domains.
    def self.cloud?(host)
      !host.nil? && host.end_with?('.livekit.cloud')
    end

    # Normalizes a region URL to an http(s) scheme (ws -> http, wss -> https).
    def self.to_http(url)
      url.start_with?('ws') ? "http#{url[2..]}" : url
    end

    def self.host_key(uri)
      "#{uri.host}:#{uri.port}".downcase
    end

    # Returns the first region whose host has not yet been attempted.
    def self.pick_next(regions, attempted)
      regions.find { |uri| !attempted.include?(host_key(uri)) }
    end

    @cache = {}
    @cache_mutex = Mutex.new

    # Returns alternative region origins (URIs) for the given origin, fetching
    # /settings/regions if the cache is stale. Best-effort: on a fetch failure
    # it serves a stale cached list when available, otherwise an empty list.
    # Forwards headers so a valid token — and any test directives — reach the
    # discovery endpoint.
    def self.region_uris(origin, headers)
      key = host_key(origin)
      @cache_mutex.synchronize do
        entry = @cache[key]
        return entry[:uris] if entry && (Time.now - entry[:fetched_at]) < entry[:ttl]
      end

      begin
        uris, ttl = fetch(origin, headers)
      rescue StandardError
        return @cache_mutex.synchronize { @cache[key]&.fetch(:uris, nil) } || []
      end

      # A zero TTL (e.g. Cache-Control: max-age=0) means "do not cache".
      if ttl.positive?
        @cache_mutex.synchronize do
          @cache[key] = { uris: uris, fetched_at: Time.now, ttl: ttl }
        end
      end
      uris
    end

    def self.fetch(origin, headers)
      forward = headers.reject { |k, _| %w[content-type content-length].include?(k.to_s.downcase) }
      url = "#{origin.scheme}://#{origin.host}:#{origin.port}/settings/regions"
      resp = Faraday.get(url) do |req|
        # Short timeout so a slow/unreachable discovery endpoint doesn't stall
        # the failover path.
        req.options.timeout = 2
        forward.each { |k, v| req.headers[k] = v }
      end
      raise "region discovery failed: #{resp.status}" unless resp.status == 200

      ttl = parse_max_age(resp.headers['cache-control'])
      body = JSON.parse(resp.body || '{}')
      uris = (body['regions'] || [])
             .map { |r| r['url'] }
             .reject { |u| u.nil? || u.empty? }
             .map { |u| URI.parse(to_http(u)) }
      [uris, ttl]
    end

    def self.parse_max_age(cache_control)
      return 0 if cache_control.nil? || cache_control.empty?

      cache_control.split(',').each do |directive|
        directive = directive.strip.downcase
        if directive.start_with?('max-age=')
          secs = directive.sub('max-age=', '').to_i
          return secs.positive? ? secs : 0
        end
      end
      0
    end
  end

  # Faraday middleware that fails over to alternative LiveKit Cloud regions on a
  # retryable error: any transport error or HTTP 5xx. A 4xx is returned
  # immediately. The request body and headers are replayed intact against the
  # next untried region, with exponential backoff.
  class RegionFailoverMiddleware < Faraday::Middleware
    def initialize(app, options = {})
      super(app)
      @failover = options.fetch(:failover, true)
      # +force+ / +backoff_base+ are internal test-only knobs.
      @force = options.fetch(:force, false)
      @backoff_base = options.fetch(:backoff_base, Failover::BACKOFF_BASE)
    end

    def call(env)
      original_url = env.url.dup
      request_body = env.body

      # A per-request timeout override (e.g. for SIP dialing) travels as an
      # internal header; consume it so it isn't sent to the server. Otherwise
      # use the connection's configured timeout.
      timeout = env.request_headers.delete(Failover::TIMEOUT_HEADER)&.to_f
      timeout ||= env.request.timeout
      env.request.timeout = timeout if timeout

      request_headers = env.request_headers.dup
      max_attempts = Failover.attempts(@failover, original_url.host, @force, timeout)

      attempted = [Failover.host_key(original_url)]
      regions = nil
      current_url = original_url
      attempt = 0

      loop do
        is_last = attempt + 1 >= max_attempts
        env.url = current_url
        env.body = request_body

        response = nil
        error = nil
        begin
          response = @app.call(env)
        rescue Faraday::Error => e
          error = e
        end

        # Success or a non-retryable 4xx is terminal.
        return response if response && response.status < 500

        nxt = nil
        unless is_last
          regions ||= Failover.region_uris(original_url, request_headers)
          nxt = Failover.pick_next(regions, attempted)
        end

        if nxt.nil?
          return response if response
          raise error
        end

        reason = response ? "status #{response.status}" : (error&.message || 'error')
        warn("livekit API request to #{current_url.host} failed (#{reason}), " \
             "retrying with fallback url #{nxt}")
        sleep(@backoff_base * (2**attempt))
        attempted << Failover.host_key(nxt)
        # Swap only the region's scheme/host/port, preserving the request path.
        current_url = original_url.dup
        current_url.scheme = nxt.scheme
        current_url.host = nxt.host
        current_url.port = nxt.port
        attempt += 1
      end
    end
  end
end
