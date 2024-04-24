require "livekit/proto/livekit_ingress_twirp"
require "livekit/auth_mixin"
require 'livekit/utils'

module LiveKit
  class IngressServiceClient < Twirp::Client
    client_for Proto::IngressService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(Utils.to_http_url(base_url), "/twirp"))
      @api_key = api_key
      @api_secret = api_secret
    end

    def create_ingress(
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
      video: nil,
      # optional, whether to forward input media unprocessed, for WHIP only [deprecated]
      bypass_transcoding: nil,
      # optional, whether to enable transcoding or forward the input media directly.
      # Transcoding is required for all input types except WHIP. For WHIP, the default is to not transcode.
      enable_transcoding: nil,
      # optional, needed for ingresses of type URL, provides the URL to fetch media from
      url: nil
    )
      request = Proto::CreateIngressRequest.new(
        input_type: input_type,
        name: name,
        room_name: room_name,
        participant_identity: participant_identity,
        participant_name: participant_name,
        audio: audio,
        video: video,
        bypass_transcoding: bypass_transcoding,
        enable_transcoding: enable_transcoding,
        url: url,
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
      video: nil,
      # optional, whether to forward input media unprocessed, for WHIP only
      bypass_transcoding: nil
      # optional, whether to enable transcoding or forward the input media directly.
      # Transcoding is required for all input types except WHIP. For WHIP, the default is to not transcode.
      enable_transcoding: nil,
    )
      request = Proto::UpdateIngressRequest.new(
        ingress_id: ingress_id,
        name: name,
        room_name: room_name,
        participant_identity: participant_identity,
        participant_name: participant_name,
        audio: audio,
        video: video,
        bypass_transcoding: bypass_transcoding,
        enable_transcoding: enable_transcoding,
      )
      self.rpc(
        :UpdateIngress,
        request,
        headers: auth_header(ingressAdmin: true),
      )
    end

    def list_ingress(
      # optional, filter by room name
      room_name: nil,
      # optional, list by ingress id
      ingress_id: nil
    )
      request = Proto::ListIngressRequest.new(
        room_name: room_name,
        ingress_id: ingress_id,
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
