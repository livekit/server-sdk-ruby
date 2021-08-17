# frozen_string_literal: true

require 'jwt'

module Livekit
  class Credentials
    # 6 hours in seconds
    DEFAULT_TTL = 14_400

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
    end
  end
end
