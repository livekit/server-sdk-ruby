# Code generated by protoc-gen-twirp_ruby 1.9.0, DO NOT EDIT.
require 'twirp'
require_relative 'livekit_room_pb.rb'

module LiveKit
  module Proto
    class RoomServiceService < Twirp::Service
      package 'livekit'
      service 'RoomService'
      rpc :CreateRoom, CreateRoomRequest, Room, :ruby_method => :create_room
      rpc :ListRooms, ListRoomsRequest, ListRoomsResponse, :ruby_method => :list_rooms
      rpc :DeleteRoom, DeleteRoomRequest, DeleteRoomResponse, :ruby_method => :delete_room
      rpc :ListParticipants, ListParticipantsRequest, ListParticipantsResponse, :ruby_method => :list_participants
      rpc :GetParticipant, RoomParticipantIdentity, ParticipantInfo, :ruby_method => :get_participant
      rpc :RemoveParticipant, RoomParticipantIdentity, RemoveParticipantResponse, :ruby_method => :remove_participant
      rpc :MutePublishedTrack, MuteRoomTrackRequest, MuteRoomTrackResponse, :ruby_method => :mute_published_track
      rpc :UpdateParticipant, UpdateParticipantRequest, ParticipantInfo, :ruby_method => :update_participant
      rpc :UpdateSubscriptions, UpdateSubscriptionsRequest, UpdateSubscriptionsResponse, :ruby_method => :update_subscriptions
      rpc :SendData, SendDataRequest, SendDataResponse, :ruby_method => :send_data
      rpc :UpdateRoomMetadata, UpdateRoomMetadataRequest, Room, :ruby_method => :update_room_metadata
    end

    class RoomServiceClient < Twirp::Client
      client_for RoomServiceService
    end
  end
end
