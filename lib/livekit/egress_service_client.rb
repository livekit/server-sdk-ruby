require "livekit/proto/livekit_egress_twirp"
require "livekit/auth_mixin"
require 'livekit/utils'

module LiveKit
  class EgressServiceClient < Twirp::Client
    client_for Proto::EgressService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(Utils.to_http_url(base_url), "/twirp"))
      @api_key = api_key
      @api_secret = api_secret
    end

    def start_room_composite_egress(
      room_name,
      # EncodedFileOutput, SegmentedFileOutput, StreamOutput, ImageOutput or array containing up to one of each
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

    def start_participant_egress(
      room_name,
      identity,
      # EncodedFileOutput, SegmentedFileOutput, StreamOutput, ImageOutput, or array containing up to one of each
      output,
      # true to record the participant's screenshare and screenshare_audio track
      screen_share: false,
      # EncodingOptionsPreset, only one of preset or advanced could be set
      preset: nil,
      # EncodingOptions, only one of preset or advanced could be set
      advanced: nil
    )
      request = Proto::ParticipantEgressRequest.new(
        room_name: room_name,
        identity: identity,
        screen_share: screen_share,
        preset: preset,
        advanced: advanced,
      )
      self.set_output(request, output)
      self.rpc(
        :StartParticipantEgress,
        request,
        headers: auth_header(roomRecord: true),
      )
    end

    def start_track_composite_egress(
      room_name,
      # EncodedFileOutput, SegmentedFileOutput, StreamOutput, ImageOutput, or array containing up to one of each
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

    def start_web_egress(
      url,
      # EncodedFileOutput, SegmentedFileOutput, StreamOutput, ImageOutput, or array containing up to one of each
      output,
      # EncodingOptionsPreset, only one of preset or advanced could be set
      preset: nil,
      # EncodingOptions, only one of preset or advanced could be set
      advanced: nil,
      # true to record only audio
      audio_only: false,
      # true to record only video
      video_only: false,
      # true to await START_RECORDING chrome log
      await_start_signal: false
    )
      request = Proto::WebEgressRequest.new(
        url: url,
        preset: preset,
        advanced: advanced,
        audio_only: audio_only,
        video_only: video_only,
        await_start_signal: await_start_signal,
      )
      self.set_output(request, output)
      self.rpc(
        :StartWebEgress,
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
          add_output_urls: add_output_urls,
          remove_output_urls: remove_output_urls,
        ),
        headers: auth_header(roomRecord: true),
      )
    end

    # list all egress or only egress for a room
    def list_egress(
      room_name: nil,
      egress_id: nil,
      active: false
    )
      self.rpc(
        :ListEgress,
        Proto::ListEgressRequest.new(
          room_name: room_name,
          active: active,
          egress_id: egress_id,
        ),
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
      raise "output cannot be nil" if output.nil?
      # note: because we are setting the outputs fields here, instead of in the initialilzer
      # we'll need to use the ugly Google::Protobuf::RepeatedField wrappers instead of
      # a regular array
      if output.is_a? Array
        output.each do |out|
          if out.is_a? LiveKit::Proto::EncodedFileOutput
            raise "cannot add multiple file outputs" if request.file_outputs.any?
            request.file_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::EncodedFileOutput, [out])
          elsif out.is_a? LiveKit::Proto::SegmentedFileOutput
            raise "cannot add multiple segmented file outputs" if request.segment_outputs.any?
            request.segment_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::SegmentedFileOutput, [out])
          elsif out.is_a? Livekit::Proto::StreamOutput
            raise "cannot add multiple stream outputs" if request.stream_outputs.any?
            request.stream_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::StreamOutput, [out])
          elsif out.is_a? LiveKit::Proto::ImageOutput
            raise "cannot add multiple image outputs" if request.image_outputs.any?
            request.image_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::ImageOutput, [out])
          end
        end
      elsif output.is_a? LiveKit::Proto::EncodedFileOutput
        request.file = output
        request.file_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::EncodedFileOutput, [output])
      elsif output.is_a? LiveKit::Proto::SegmentedFileOutput
        request.segments = output
        request.segment_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::SegmentedFileOutput, [output])
      elsif output.is_a? LiveKit::Proto::StreamOutput
        request.stream = output
        request.stream_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::StreamOutput, [output])
      elsif output.is_a? LiveKit::Proto::ImageOutput
        request.image_outputs = Google::Protobuf::RepeatedField.new(:message, Proto::ImageOutput, [output])
      end
    end
  end
end
