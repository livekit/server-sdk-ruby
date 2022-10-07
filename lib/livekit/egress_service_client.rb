require "livekit/proto/livekit_egress_twirp"
require "livekit/auth_mixin"

module LiveKit
  class EgressServiceClient < Twirp::Client
    client_for Proto::EgressService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(base_url, "/twirp"))
      @api_key = api_key
      @api_secret = api_secret
    end

    def start_room_composite_egress(
      room_name,
      # one of EncodedFileOutput, SegmentedFileOutput or StreamOutput
      output,
      # EncodingOptionsPreset, only one of preset or advanced could be set
      preset: nil,
      # EncodingOptions, only one of preset or advanced could be set
      advanced: nil,
      # egress template url, otherwise uses default templates
      custom_base_url: nil,
      # egress layout
      layout: nil,
      # true to record only audio
      audio_only: false,
      # true to record only video
      video_only: false
    )
      request = Proto::RoomCompositeEgressRequest.new(
        room_name: room_name,
        preset: preset,
        advanced: advanced,
        layout: layout,
        custom_base_url: custom_base_url,
        audio_only: audio_only,
        video_only: video_only,
      )
      self.set_output(request, output)
      self.rpc(
        :StartRoomCompositeEgress,
        request,
        headers: auth_header(roomRecord: true),
      )
    end

    def start_track_composite_egress(
      room_name,
      # one of EncodedFileOutput, SegmentedFileOutput or StreamOutput
      output,
      # TrackID of an audio track
      audio_track_id: nil,
      # TrackID of a video track
      video_track_id: nil,
      # EncodingOptionsPreset, only one of preset or advanced could be set
      preset: nil,
      # EncodingOptions, only one of preset or advanced could be set
      advanced: nil
    )
      request = Proto::TrackCompositeEgressRequest.new(
        room_name: room_name,
        preset: preset,
        advanced: advanced,
        audio_track_id: audio_track_id,
        video_track_id: video_track_id,
      )
      self.set_output(request, output)
      self.rpc(
        :StartTrackCompositeEgress,
        request,
        headers: auth_header(roomRecord: true),
      )
    end

    def start_track_egress(
      room_name,
      # either a DirectFileOutput - egress to storage or string - egress to WebSocket URL
      output,
      track_id
    )
      request = Proto::TrackEgressRequest.new(
        room_name: room_name,
        track_id: track_id,
      )
      if output.filepath
        request.file = output
      else
        request.websocket_url = output
      end
      self.rpc(
        :StartTrackEgress,
        request,
        headers: auth_header(roomRecord: true),
      )
    end


    def update_layout(egress_id, layout)
      self.rpc(
        :UpdateLayout,
        Proto::UpdateLayoutRequest.new(
          egress_id: egress_id,
          layout: layout,
        ),
        headers: auth_header(roomRecord: true),
      )
    end

    def update_stream(egress_id,
      add_output_urls: [],
      remove_output_urls: []
    )
      self.rpc(
        :UpdateStream,
        Proto::UpdateStreamRequest.new(
          egress_id: egress_id,
          add_output_urls: Google::Protobuf::RepeatedField.new(:string, add_output_urls.to_a),
          remove_output_urls: Google::Protobuf::RepeatedField.new(:string, remove_output_urls.to_a),
        ),
        headers: auth_header(roomRecord: true),
      )
    end

    # list all egress or only egress for a room
    def list_egress(room_name: nil)
      self.rpc(
        :ListEgress,
        Proto::ListEgressRequest.new(room_name: room_name),
        headers: auth_header(roomRecord: true),
      )
    end

    def stop_egress(egress_id)
      self.rpc(
        :StopEgress,
        Proto::StopEgressRequest.new(egress_id: egress_id),
        headers: auth_header(roomRecord: true),
      )
    end

    private

    # helper that sets output to file or stream
    def set_output(request, output)
      if output.nil?
        raise "output cannot be nil"
      end
      if output.is_a? LiveKit::Proto::EncodedFileOutput or output.is_a? LiveKit::Proto::DirectFileOutput
        request.file = output
      elsif output.is_a? LiveKit::Proto::SegmentedFileOutput
        request.segments = output
      else
        request.stream = output
      end
    end
  end
end
