# frozen_string_literal: true

TEST_KEY = "API87mWmmh7KM3V"
TEST_SECRET = "helOnxxeT71NeOEBcYm3kW0s1pofQAbitubCw7AIsY0A"

RSpec.describe LiveKit::AccessToken do
  it "generates a valid JWT with defaults" do
    token = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET)
    token.add_grant LiveKit::VideoGrant.new
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
    token.add_grant(LiveKit::VideoGrant.new(roomJoin: true, room: "myroom", canPublish: false))
    jwt = token.to_jwt

    decoded = JWT.decode(jwt, TEST_SECRET, true, algorithm: "HS256")
    expect(decoded.first["name"]).to eq("myname")
    video_grant = decoded.first["video"]
    expect(video_grant["roomJoin"]).to eq(true)
    expect(video_grant["room"]).to eq("myroom")
    expect(video_grant["canPublish"]).to eq(false)
  end
end
