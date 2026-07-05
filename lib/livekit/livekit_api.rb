# frozen_string_literal: true

require "livekit/room_service_client"
require "livekit/egress_service_client"
require "livekit/ingress_service_client"
require "livekit/sip_service_client"
require "livekit/agent_dispatch_service_client"
require "livekit/connector_service_client"

module LiveKit
  # A single entry point to every LiveKit server API, exposing each service
  # through a reader.
  #
  # @example
  #   api = LiveKit::LiveKitAPI.new("https://my.livekit.host", api_key: k, api_secret: s)
  #   api.room.create_room("my-room")
  class LiveKitAPI
    # @return [RoomServiceClient]
    attr_reader :room
    # @return [EgressServiceClient]
    attr_reader :egress
    # @return [IngressServiceClient]
    attr_reader :ingress
    # @return [SIPServiceClient]
    attr_reader :sip
    # @return [AgentDispatchServiceClient]
    attr_reader :agent_dispatch
    # @return [ConnectorServiceClient]
    attr_reader :connector

    # Authenticate with either an API key and secret (recommended for backend
    # use), or a pre-signed +token+ (for client-side use, where the API secret
    # must not be exposed). Any omitted value falls back to its environment
    # variable: +LIVEKIT_URL+, +LIVEKIT_TOKEN+, +LIVEKIT_API_KEY+, +LIVEKIT_API_SECRET+.
    def initialize(url = nil, api_key: nil, api_secret: nil, token: nil, failover: true)
      url ||= ENV["LIVEKIT_URL"]
      token ||= ENV["LIVEKIT_TOKEN"]
      api_key ||= ENV["LIVEKIT_API_KEY"]
      api_secret ||= ENV["LIVEKIT_API_SECRET"]

      raise ArgumentError, "url is required (pass it or set LIVEKIT_URL)" if url.nil? || url.empty?
      if token.nil? && (api_key.nil? || api_secret.nil?)
        raise ArgumentError, "either a token, or api_key and api_secret, are required"
      end

      opts = { api_key: api_key, api_secret: api_secret, token: token, failover: failover }
      @room = RoomServiceClient.new(url, **opts)
      @egress = EgressServiceClient.new(url, **opts)
      @ingress = IngressServiceClient.new(url, **opts)
      @sip = SIPServiceClient.new(url, **opts)
      @agent_dispatch = AgentDispatchServiceClient.new(url, **opts)
      @connector = ConnectorServiceClient.new(url, **opts)
    end
  end
end
