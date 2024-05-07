# frozen_string_literal: true

module LiveKit
  class ClaimGrant
    attr_accessor :identity, :name, :metadata, :sha256, :video

    def self.from_hash(hash)
      return nil if hash.nil?

      claim_grant = ClaimGrant.new
      claim_grant.identity = hash["sub"]
      claim_grant.name = hash["name"]
      claim_grant.metadata = hash["metadata"]
      claim_grant.sha256 = hash["sha256"]
      claim_grant.video = VideoGrant.from_hash(hash["video"])
      return claim_grant
    end

    def initialize
      @identity = nil
      @name = nil
      @metadata = nil
      @sha256 = nil
      @video = nil
    end

    def to_hash
      {
        name: @name,
        metadata: @metadata,
        sha256: @sha256,
        video: @video.to_hash,
      }
    end
  end

  class VideoGrant
    attr_accessor :roomCreate, :roomJoin, :roomList, :roomRecord, :roomAdmin,
      :room, :canPublish, :canPublishSources, :canSubscribe, :canPublishData,
      :canUpdateOwnMetadata, :hidden, :recorder, :ingressAdmin

    def initialize(
      # true if can create or delete rooms
      roomCreate: nil,
      # true if can join room
      roomJoin: nil,
      # true if can list rooms
      roomList: nil,
      # true if can record
      roomRecord: nil,
      # true if can manage the room
      roomAdmin: nil,
      # name of the room for join or admin permissions
      room: nil,
      # for join tokens, can participant publish, true by default
      canPublish: nil,
      # TrackSource types that a participant may publish
      canPublishSources: nil,
      # for join tokens, can participant subscribe, true by default
      canSubscribe: nil,
      # for join tokens, can participant publish data messages, true by default
      canPublishData: nil,
      # by default, a participant is not allowed to update its own metadata
      canUpdateOwnMetadata: nil,
      # if participant should remain invisible to others
      hidden: nil,
      # if participant is recording the room
      recorder: nil,
      # can create and manage Ingress
      ingressAdmin: nil
    )
      @roomCreate = roomCreate
      @roomJoin = roomJoin
      @roomList = roomList
      @roomRecord = roomRecord
      @roomAdmin = roomAdmin
      @room = room
      @canPublish = canPublish
      @canPublishSources = canPublishSources
      @canSubscribe = canSubscribe
      @canPublishData = canPublishData
      @canUpdateOwnMetadata = canUpdateOwnMetadata
      @hidden = hidden
      @recorder = recorder
      @ingressAdmin = ingressAdmin
    end

    def self.from_hash(hash)
      return nil if hash.nil?

      hash = hash.transform_keys(&:to_s)

      VideoGrant.new(
        roomCreate: hash["roomCreate"],
        roomJoin: hash["roomJoin"],
        roomList: hash["roomList"],
        roomRecord: hash["roomRecord"],
        roomAdmin: hash["roomAdmin"],
        room: hash["room"],
        canPublish: hash["canPublish"],
        canPublishSources: hash["canPublishSources"],
        canSubscribe: hash["canSubscribe"],
        canPublishData: hash["canPublishData"],
        canUpdateOwnMetadata: hash["canUpdateOwnMetadata"],
        hidden: hash["hidden"],
        recorder: hash["recorder"],
        ingressAdmin: hash["ingressAdmin"]
      )
    end

    def to_hash
      hash = {}
      instance_variables.each { |var|
        val = instance_variable_get(var)
        if val != nil
          hash[var.to_s.delete("@")] = val
        end
      }
      hash
    end
  end
end
