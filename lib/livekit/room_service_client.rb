require "livekit/proto/livekit_room_twirp"
require "livekit/auth_mixin"

module LiveKit
  class RoomServiceClient < Twirp::Client
    client_for Proto::RoomServiceService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(base_url, "/twirp"))
      @api_key = api_key
      @api_secret = api_secret
    end

    def create_room(name, empty_timeout: nil, max_participants: nil)
      self.rpc(
        :CreateRoom,
        Proto::CreateRoomRequest.new(name: name, empty_timeout: empty_timeout, max_participants: max_participants),
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

    def update_participant(room:, identity:, metadata: nil, permission: nil)
      req = Proto::UpdateParticipantRequest.new(room: room, identity: identity)
      if metadata
        req.metadata = metadata
      end
      if permission
        req.permission = permission
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

    def send_data(room:, data:, kind:, destination_sids: [])
      self.rpc(
        :SendData,
        Proto::SendDataRequest.new(
          room: room,
          data: data,
          kind: kind,
          destination_sids: destination_sids,
        ),
        headers: auth_header(roomAdmin: true, room: room),
      )
    end
  end
end
