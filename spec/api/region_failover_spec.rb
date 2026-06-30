# frozen_string_literal: true

require 'faraday'
require 'livekit/failover'

# Region failover tests against the shared mock LiveKit API server
# (livekit/livekit cmd/test-server). Point them at a running instance with
# LK_TEST_SERVER_URL (default http://127.0.0.1:9999); they skip when no server
# is reachable. The mock returns Cache-Control: max-age=0, so the region cache
# never stores entries and scenarios don't interfere.
#
# See cmd/test-server/README.md for the X-Lk-Mock-* control protocol. These
# tests drive the middleware directly because the service client methods do not
# expose per-call headers.
RSpec.describe LiveKit::RegionFailoverMiddleware do
  base = ENV.fetch('LK_TEST_SERVER_URL', 'http://127.0.0.1:9999')

  server_up = begin
    Faraday.get("#{base}/settings/regions").status == 200
  rescue StandardError
    false
  end

  # +force+ bypasses the cloud-host check (the mock is on 127.0.0.1) and a tiny
  # backoff keeps the tests fast — both are internal, test-only knobs.
  def call(base, directives, failover: true, force: true)
    conn = Faraday.new(url: "#{base}/twirp") do |f|
      f.use LiveKit::RegionFailoverMiddleware, failover: failover, force: force, backoff_base: 0.001
      f.adapter Faraday.default_adapter
    end
    conn.post('livekit.RoomService/CreateRoom') do |req|
      req.headers['Authorization'] = 'Bearer test-token'
      req.headers['Content-Type'] = 'application/protobuf'
      # These tests exercise failover, not authz; skip the mock's permission check.
      req.headers['X-Lk-Mock-Skip-Auth'] = 'true'
      req.body = ''
      directives.each { |k, v| req.headers[k] = v }
    end
  end

  if server_up
    it 'succeeds on the primary when healthy' do
      resp = call(base, {})
      expect(resp.status).to eq(200)
      expect(resp.headers['X-Lk-Mock-Region']).to eq('0')
    end

    it 'fails over to a healthy region when the primary is down' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0' })
      expect(resp.status).to eq(200)
      expect(resp.headers['X-Lk-Mock-Region']).to eq('1')
    end

    it 'fails over to region 2 on the third attempt' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0,1' })
      expect(resp.status).to eq(200)
      expect(resp.headers['X-Lk-Mock-Region']).to eq('2')
    end

    it 'surfaces an error when all regions are down' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0,1,2,3' })
      expect(resp.status).to eq(503)
    end

    it 'does not retry a 4xx' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0', 'X-Lk-Mock-Fail-Status' => '400' })
      expect(resp.status).to eq(400)
    end

    it 'fails over on a transport error' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0', 'X-Lk-Mock-Fail-Mode' => 'drop' })
      expect(resp.status).to eq(200)
      expect(resp.headers['X-Lk-Mock-Region']).to eq('1')
    end

    it 'surfaces the original error when region discovery is unreachable' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0', 'X-Lk-Mock-Regions-Status' => '500' })
      expect(resp.status).to eq(503)
    end

    it 'does not fail over for a non-cloud host (cloud-gated)' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0' }, force: false)
      expect(resp.status).to eq(503)
    end

    it 'does not fail over when disabled' do
      resp = call(base, { 'X-Lk-Mock-Fail-Regions' => '0' }, failover: false)
      expect(resp.status).to eq(503)
    end
  else
    it 'is skipped because the mock test server is not reachable' do
      skip "mock test server not reachable at #{base}"
    end
  end
end
