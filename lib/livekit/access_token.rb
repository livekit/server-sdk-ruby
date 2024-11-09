# frozen_string_literal: true

require "jwt"

module LiveKit
  class AccessToken
    # 10 minutes in seconds; how long the access token to the server is good for
    DEFAULT_TTL = 600

    # The signing algorithm used by the {jwt} gem internals
    SIGNING_ALGORITHM = "HS256"

    attr_accessor :grants, :identity

    def initialize(
        api_key: nil,
        api_secret: nil,
        identity: nil,
        ttl: DEFAULT_TTL,
        name: nil,
        metadata: nil,
        attributes: nil
      )
      @api_key = api_key || ENV["LIVEKIT_API_KEY"]
      @api_secret = api_secret || ENV["LIVEKIT_API_SECRET"]
      @grants = ClaimGrant.new
      @grants.name = name
      @grants.metadata = metadata
      @grants.attributes = attributes
      @identity = identity
      @ttl = ttl
    end

    # Deprecated, use video_grant = instead
    def add_grant(video_grant)
      if video_grant.is_a?(Hash)
        video_grant = VideoGrant.from_hash(video_grant)
      end
      self.video_grant = video_grant
    end

    def video_grant=(video_grant)
      @grants.video = video_grant
    end

    # Deprecated, use sip_grant = instead
    def add_sip_grant(sip_grant)
      if sip_grant.is_a?(Hash)
        sip_grant = SIPGrant.from_hash(sip_grant)
      end
      self.sip_grant = sip_grant
    end

    def sip_grant=(sip_grant)
      @grants.sip = sip_grant
    end

    def metadata=(participant_md)
      @grants.metadata = participant_md
    end

    def attributes=(participant_attributes)
      @grants.attributes = participant_attributes
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

    def room_config=(room_config)
      @grants.room_config = room_config
    end

    def room_preset=(room_preset)
      @grants.room_preset = room_preset
    end

    def to_jwt
      if @grants.video.nil? && @grants.sip.nil?
        raise ArgumentError, "VideoGrant or SIPGrant is required"
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
      payload.compact!

      return JWT.encode(payload, @api_secret, SIGNING_ALGORITHM)
    end
  end
end
