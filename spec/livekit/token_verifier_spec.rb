# frozen_string_literal: true

RSpec.describe LiveKit::TokenVerifier do
  it "verifies valid tokens" do
    token = LiveKit::AccessToken.new(api_key: TEST_KEY, api_secret: TEST_SECRET,
                                     identity: "user")
    token.name = "name"
    token.set_video_grant LiveKit::VideoGrant.new(roomJoin: true, room: "testroom")
    jwt = token.to_jwt
    v = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET)
    grant = v.verify(jwt)
    expect(grant.video.roomJoin).to eq(true)
    expect(grant.video.room).to eq("testroom")
    expect(grant.name).to eq("name")
    expect(grant.identity).to eq("user")
  end

  it "fails on expired tokens" do
    token = LiveKit::AccessToken.new(api_key: TEST_KEY, api_secret: TEST_SECRET,
                                     identity: "test_identity", ttl: -10)
    token.set_video_grant(LiveKit::VideoGrant.new(roomJoin: true))
    jwt = token.to_jwt

    v = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET)
    expect { v.verify(jwt) }.to raise_error(JWT::ExpiredSignature)
  end

  it "fails on invalid secret" do
    token = LiveKit::AccessToken.new(api_key: TEST_KEY, api_secret: TEST_SECRET,
                                     identity: "test_identity")
    token.set_video_grant(LiveKit::VideoGrant.new(roomJoin: true))
    jwt = token.to_jwt

    v = described_class.new(api_key: TEST_KEY, api_secret: "wrong-secret")
    expect { v.verify(jwt) }.to raise_error(JWT::VerificationError)
  end

  it "fails on invalid api-key" do
    token = LiveKit::AccessToken.new(api_key: TEST_KEY, api_secret: TEST_SECRET,
                                     identity: "test_identity")
    token.set_video_grant(LiveKit::VideoGrant.new(roomJoin: true))
    jwt = token.to_jwt

    v = described_class.new(api_key: "wrong key", api_secret: TEST_SECRET)
    expect { v.verify(jwt) }.to raise_error
  end
end
