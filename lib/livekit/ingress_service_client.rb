require "livekit/proto/livekit_ingress_twirp"
require "livekit/auth_mixin"

module LiveKit
  class IngressServiceClient < Twirp::Client
    client_for Proto::IngressService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(base_url, "/twirp"))
      @api_key = api_key
      @api_secret = api_secret
    end

    def create_ingress(
      # currently :RTMP_INPUT is the only supported type
      input_type,
      # optional, name to identify the ingress
      name: nil,
      # optional, you can attach to a room at a later time
      room_name: nil,
      # optional, identity of participant to publish as
      participant_identity: nil,
      # optional, display name of participant
      participant_name: nil,
      # optional, LiveKit::Proto::IngressAudioOptions
      audio: nil,
      # optional, LiveKit::Proto::IngressVideoOptions
      video: nil
    )
      request = Proto::CreateIngressRequest.new(
        input_type: input_type,
        name: name,
        room_name: room_name,
        participant_identity: participant_identity,
        participant_name: participant_name,
        audio: audio,
        video: video,
      )
      self.rpc(
        :CreateIngress,
        request,
        headers: auth_header(ingressAdmin: true),
      )
    end

    def update_ingress(
      ingress_id,
      # optional, name to identify the ingress
      name: nil,
      # optional, you can attach to a room at a later time
      room_name: nil,
      # optional, identity of participant to publish as
      participant_identity: nil,
      # optional, display name of participant
      participant_name: nil,
      # optional, LiveKit::Proto::IngressAudioOptions
      audio: nil,
      # optional, LiveKit::Proto::IngressVideoOptions
      video: nil
    )
      request = Proto::UpdateIngressRequest.new(
        ingress_id: ingress_id,
        name: name,
        room_name: room_name,
        participant_identity: participant_identity,
        participant_name: participant_name,
        audio: audio,
        video: video,
      )
      self.rpc(
        :UpdateIngress,
        request,
        headers: auth_header(ingressAdmin: true),
      )
    end

    def list_ingress(room_name: nil)
      request = Proto::ListIngressRequest.new(
        room_name: room_name,
      )
      self.rpc(
        :ListIngress,
        request,
        headers: auth_header(ingressAdmin: true),
      )
    end

    def delete_ingress(ingress_id)
      request = Proto::DeleteIngressRequest.new(
        ingress_id: ingress_id
      )
      self.rpc(
        :DeleteIngress,
        request,
        headers: auth_header(ingressAdmin: true),
      )
    end
  end
end
