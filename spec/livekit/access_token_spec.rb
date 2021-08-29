# frozen_string_literal: true

TEST_KEY = "API87mWmmh7KM3V"
TEST_SECRET = "helOnxxeT71NeOEBcYm3kW0s1pofQAbitubCw7AIsY0A"

RSpec.describe Livekit::AccessToken do
  it 'generates a valid JWT with defaults' do
    token = described_class.new(api_key: TEST_KEY, api_secret: TEST_SECRET)
    jwt = token.to_jwt
    decoded = JWT.decode(jwt, TEST_SECRET, true, algorithm: 'HS256')
    expect(decoded.first["iss"]).to eq(TEST_KEY)
  end
end
