# frozen_string_literal: true

require "jwt"

module LiveKit
  class AccessToken
    # 6 hours in seconds; how long the access token to the server is good for
    DEFAULT_TTL = 14_400

    # The signing algorithm used by the {jwt} gem internals
    SIGNING_ALGORITHM = "HS256"

    attr_accessor :grants, :identity

    def initialize(api_key: nil, api_secret: nil, identity: nil, ttl: DEFAULT_TTL, name: nil, metadata: nil)
      @api_key = api_key || ENV["LIVEKIT_API_KEY"]
      @api_secret = api_secret || ENV["LIVEKIT_API_SECRET"]
      @grants = ClaimGrant.new
      @grants.name = name
      @grants.metadata = metadata
      @identity = identity
      @ttl = ttl
    end

    def add_grant(video_grant)
      if video_grant.is_a?(Hash)
        video_grant = VideoGrant.from_hash(video_grant)
      end
      @grants.video = video_grant
    end

    def metadata=(participant_md)
      @grants.metadata = participant_md
    end

    def name=(participant_name)
      @grants.name = participant_name
    end

    def sha256
      @grants.sha256
    end

    def sha256=(sha_string)
      @grants.sha256 = sha_string
    end

    def to_jwt
      if @grants.video.nil?
        raise ArgumentError, "VideoGrant is required"
      end

      jwt_timestamp = Time.now.to_i
      payload = {}
      payload.merge!(@grants.to_hash)
      payload.merge!({
        exp: jwt_timestamp + @ttl,
        nbf: jwt_timestamp - 5,
        iss: @api_key,
        sub: @identity,
      })

      return JWT.encode(payload, @api_secret, SIGNING_ALGORITHM)
    end
  end
end
