# frozen_string_literal: true

require "livekit/proto/livekit_room_twirp"
require "livekit/auth_mixin"
require 'livekit/utils'

module LiveKit
  class RoomServiceClient < Twirp::Client
    client_for Proto::RoomServiceService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(Utils.to_http_url(base_url), "/twirp"))
      @api_key = api_key
      @api_secret = api_secret
    end

    def create_room(name,
        empty_timeout: nil,
        max_participants: nil,
        egress: nil,
        metadata: nil,
        min_playout_delay: nil,
        max_playout_delay: nil,
        sync_streams: nil,
        departure_timeout: nil
      )
      self.rpc(
        :CreateRoom,
        Proto::CreateRoomRequest.new(
          name: name,
          empty_timeout: empty_timeout,
          departure_timeout: departure_timeout,
          max_participants: max_participants,
          egress: egress,
          metadata: metadata,
          min_playout_delay: min_playout_delay,
          max_playout_delay: max_playout_delay,
          sync_streams: sync_streams
        ),
        headers: auth_header(roomCreate: true),
      )
    end

    def list_rooms(names: nil)
      self.rpc(
        :ListRooms,
        Proto::ListRoomsRequest.new(names: names),
        headers: auth_header(roomList: true),
      )
    end

    def delete_room(room:)
      self.rpc(
        :DeleteRoom,
        Proto::DeleteRoomRequest.new(room: room),
        headers: auth_header(roomCreate: true),
      )
    end

    def update_room_metadata(room:, metadata:)
      self.rpc(
        :UpdateRoomMetadata,
        Proto::UpdateRoomMetadataRequest.new(room: room, metadata: metadata),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end

    def list_participants(room:)
      self.rpc(
        :ListParticipants,
        Proto::ListParticipantsRequest.new(room: room),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end

    def get_participant(room:, identity:)
      self.rpc(
        :GetParticipant,
        Proto::RoomParticipantIdentity.new(room: room, identity: identity),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end

    def remove_participant(room:, identity:)
      self.rpc(
        :RemoveParticipant,
        Proto::RoomParticipantIdentity.new(room: room, identity: identity),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end

    def mute_published_track(room:, identity:, track_sid:, muted:)
      self.rpc(
        :MutePublishedTrack,
        Proto::MuteRoomTrackRequest.new(
          room: room,
          identity: identity,
          track_sid: track_sid,
          muted: muted,
        ),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end

    def update_participant(room:, identity:, metadata: nil, permission: nil, name: nil)
      req = Proto::UpdateParticipantRequest.new(room: room, identity: identity)
      if metadata
        req.metadata = metadata
      end
      if permission
        req.permission = permission
      end
      if name
        req.name = name
      end
      self.rpc(
        :UpdateParticipant,
        req,
        headers: auth_header(roomAdmin: true, room: room),
      )
    end

    def update_subscriptions(room:, identity:, track_sids:, subscribe:)
      self.rpc(
        :UpdateSubscriptions,
        Proto::UpdateSubscriptionsRequest.new(
          room: room,
          identity: identity,
          track_sids: track_sids,
          subscribe: subscribe,
        ),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end

    def send_data(room:, data:, kind:,
        destination_sids: [],
        destination_identities: []
      )
      self.rpc(
        :SendData,
        Proto::SendDataRequest.new(
          room: room,
          data: data,
          kind: kind,
          destination_sids: destination_sids,
          destination_identities: destination_identities,
        ),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end
  end
end
