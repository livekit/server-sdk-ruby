# frozen_string_literal: true

require 'jwt'

module Livekit
  class AccessToken
    # 6 hours in seconds; how long the access token to the server is good for
    DEFAULT_TTL = 14_400

    # The signing algorithm used by the {jwt} gem internals
    SIGNING_ALGORITHM = 'HS256'

    def initialize(api_key: nil, api_secret: nil, identity: nil, ttl: DEFAULT_TTL, metadata: nil)
      @api_key = api_key || ENV['LIVEKIT_API_KEY']
      @api_secret = api_secret || ENV['LIVEKIT_API_SECRET']
      @grants = {}
      @identity = identity
      @ttl = ttl
      @metadata = metadata if metadata
    end

    def add_grant(video_grant)
      @grants[:video] = video_grant
    end

    def metadata=(participant_md)
      @grants[:metadata] = participant_md
    end

    def sha256
      @grants[:sha256]
    end

    def sha256=(sha_string)
      @grants[:sha256] = sha_string
    end

    def to_jwt
      jwt_timestamp = Time.now.to_i
      payload = {
        exp: jwt_timestamp + @ttl,
        nbf: jwt_timestamp,
        iss: @api_key,
        sub: @identity
      }
      payload.merge!(@grants)

      JWT.encode(payload, @api_secret, SIGNING_ALGORITHM)
    end
  end
end
