# frozen_string_literal: true

require "jwt"

module LiveKit
  class TokenVerifier
    def initialize(api_key: nil, api_secret: nil)
      @api_key = api_key
      @api_secret = api_secret
    end

    def verify(token)
      decoded_token = JWT.decode(token, @api_secret, true, algorithm: AccessToken::SIGNING_ALGORITHM)
      decoded = decoded_token.first
      if decoded["iss"] != @api_key
        raise "Invalid issuer"
      end
      ClaimGrant.from_hash(decoded)
    end
  end
end
