# frozen_string_literal: true

TEST_KEY = "API87mWmmh7KM3V"
TEST_SECRET = "helOnxxeT71NeOEBcYm3kW0s1pofQAbitubCw7AIsY0A"

RSpec.describe LiveKit::AccessToken do
  it "generates a valid JWT with defaults" do
    token = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET)
    token.video_grant = LiveKit::VideoGrant.new
    jwt = token.to_jwt
    decoded = JWT.decode(jwt, TEST_SECRET, true, algorithm: "HS256")
    expect(decoded.first["iss"]).to eq(TEST_KEY)
  end

  it "accepts hashes for grants" do
    token = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET)
    token.add_grant(roomCreate: true)
    jwt = token.to_jwt
    decoded = JWT.decode(jwt, TEST_SECRET, true, algorithm: "HS256").first
    expect(decoded["video"]["roomCreate"]).to eq(true)
  end

  it "encodes join tokens" do
    token = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET,
                                identity: "test_identity", ttl: 60)
    token.name = "myname"
    token.video_grant = LiveKit::VideoGrant.new(roomJoin: true, room: "myroom", canPublish: false)
    jwt = token.to_jwt

    decoded = JWT.decode(jwt, TEST_SECRET, true, algorithm: "HS256")
    expect(decoded.first["name"]).to eq("myname")
    video_grant = decoded.first["video"]
    expect(video_grant["roomJoin"]).to eq(true)
    expect(video_grant["room"]).to eq("myroom")
    expect(video_grant["canPublish"]).to eq(false)
  end

  it "handles agent dispatch" do
    token = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET)
    token.video_grant = LiveKit::VideoGrant.new(roomJoin: true, room: "myroom", canPublish: false)
    token.room_config = LiveKit::Proto::RoomConfiguration.new(
      max_participants: 10,
      agents: [LiveKit::Proto::RoomAgentDispatch.new(
        agent_name: "test-agent",
        metadata: "test-metadata",
      )]
    )
    jwt = token.to_jwt

    grant = LiveKit::TokenVerifier.new(api_key: TEST_KEY, api_secret: TEST_SECRET).verify(jwt)
    expect(grant.video.room).to eq("myroom")
    expect(grant.room_config.agents[0].agent_name).to eq("test-agent")
    expect(grant.room_config.agents[0].metadata).to eq("test-metadata")
  end
end

RSpec.describe LiveKit::ClaimGrant do
  it "can be converted to a hash and back" do
    claim_grant = described_class.new
    claim_grant.identity = "test_identity"
    claim_grant.name = "myname"
    claim_grant.video = LiveKit::VideoGrant.new(roomJoin: true, room: "myroom", canPublish: false)
    claim_grant.room_config = LiveKit::Proto::RoomConfiguration.new(
      max_participants: 10,
      agents: [LiveKit::Proto::RoomAgentDispatch.new(
        agent_name: "test-agent",
        metadata: "test-metadata",
      )]
    )
    hash = claim_grant.to_hash
    expect(hash[:name]).to eq("myname")
    agents = hash[:roomConfig]["agents"]
    expect(agents.size).to eq(1)
    expect(agents[0]["agentName"]).to eq("test-agent")
    expect(agents[0]["metadata"]).to eq("test-metadata")

    serialized = hash.to_json
    restored = JSON.parse(serialized)

    grant_parsed = LiveKit::ClaimGrant.from_hash(restored)
    expect(grant_parsed.name).to eq("myname")
    expect(grant_parsed.video.room).to eq("myroom")
    expect(grant_parsed.room_config.max_participants).to eq(10)
    expect(grant_parsed.room_config.agents[0].agent_name).to eq("test-agent")
    expect(grant_parsed.room_config.agents[0].metadata).to eq("test-metadata")
  end
end
