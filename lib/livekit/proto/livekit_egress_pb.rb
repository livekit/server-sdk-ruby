# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: livekit_egress.proto

require 'google/protobuf'

require 'livekit_models_pb'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("livekit_egress.proto", :syntax => :proto3) do
    add_message "livekit.RoomCompositeEgressRequest" do
      optional :room_name, :string, 1
      optional :layout, :string, 2
      optional :audio_only, :bool, 3
      optional :video_only, :bool, 4
      optional :custom_base_url, :string, 5
      repeated :file_outputs, :message, 11, "livekit.EncodedFileOutput"
      repeated :stream_outputs, :message, 12, "livekit.StreamOutput"
      repeated :segment_outputs, :message, 13, "livekit.SegmentedFileOutput"
      oneof :output do
        optional :file, :message, 6, "livekit.EncodedFileOutput"
        optional :stream, :message, 7, "livekit.StreamOutput"
        optional :segments, :message, 10, "livekit.SegmentedFileOutput"
      end
      oneof :options do
        optional :preset, :enum, 8, "livekit.EncodingOptionsPreset"
        optional :advanced, :message, 9, "livekit.EncodingOptions"
      end
    end
    add_message "livekit.WebEgressRequest" do
      optional :url, :string, 1
      optional :audio_only, :bool, 2
      optional :video_only, :bool, 3
      optional :await_start_signal, :bool, 12
      repeated :file_outputs, :message, 9, "livekit.EncodedFileOutput"
      repeated :stream_outputs, :message, 10, "livekit.StreamOutput"
      repeated :segment_outputs, :message, 11, "livekit.SegmentedFileOutput"
      oneof :output do
        optional :file, :message, 4, "livekit.EncodedFileOutput"
        optional :stream, :message, 5, "livekit.StreamOutput"
        optional :segments, :message, 6, "livekit.SegmentedFileOutput"
      end
      oneof :options do
        optional :preset, :enum, 7, "livekit.EncodingOptionsPreset"
        optional :advanced, :message, 8, "livekit.EncodingOptions"
      end
    end
    add_message "livekit.TrackCompositeEgressRequest" do
      optional :room_name, :string, 1
      optional :audio_track_id, :string, 2
      optional :video_track_id, :string, 3
      repeated :file_outputs, :message, 11, "livekit.EncodedFileOutput"
      repeated :stream_outputs, :message, 12, "livekit.StreamOutput"
      repeated :segment_outputs, :message, 13, "livekit.SegmentedFileOutput"
      oneof :output do
        optional :file, :message, 4, "livekit.EncodedFileOutput"
        optional :stream, :message, 5, "livekit.StreamOutput"
        optional :segments, :message, 8, "livekit.SegmentedFileOutput"
      end
      oneof :options do
        optional :preset, :enum, 6, "livekit.EncodingOptionsPreset"
        optional :advanced, :message, 7, "livekit.EncodingOptions"
      end
    end
    add_message "livekit.TrackEgressRequest" do
      optional :room_name, :string, 1
      optional :track_id, :string, 2
      oneof :output do
        optional :file, :message, 3, "livekit.DirectFileOutput"
        optional :websocket_url, :string, 4
      end
    end
    add_message "livekit.EncodedFileOutput" do
      optional :file_type, :enum, 1, "livekit.EncodedFileType"
      optional :filepath, :string, 2
      optional :disable_manifest, :bool, 6
      oneof :output do
        optional :s3, :message, 3, "livekit.S3Upload"
        optional :gcp, :message, 4, "livekit.GCPUpload"
        optional :azure, :message, 5, "livekit.AzureBlobUpload"
        optional :aliOSS, :message, 7, "livekit.AliOSSUpload"
      end
    end
    add_message "livekit.SegmentedFileOutput" do
      optional :protocol, :enum, 1, "livekit.SegmentedFileProtocol"
      optional :filename_prefix, :string, 2
      optional :playlist_name, :string, 3
      optional :segment_duration, :uint32, 4
      optional :filename_suffix, :enum, 10, "livekit.SegmentedFileSuffix"
      optional :disable_manifest, :bool, 8
      oneof :output do
        optional :s3, :message, 5, "livekit.S3Upload"
        optional :gcp, :message, 6, "livekit.GCPUpload"
        optional :azure, :message, 7, "livekit.AzureBlobUpload"
        optional :aliOSS, :message, 9, "livekit.AliOSSUpload"
      end
    end
    add_message "livekit.DirectFileOutput" do
      optional :filepath, :string, 1
      optional :disable_manifest, :bool, 5
      oneof :output do
        optional :s3, :message, 2, "livekit.S3Upload"
        optional :gcp, :message, 3, "livekit.GCPUpload"
        optional :azure, :message, 4, "livekit.AzureBlobUpload"
        optional :aliOSS, :message, 6, "livekit.AliOSSUpload"
      end
    end
    add_message "livekit.S3Upload" do
      optional :access_key, :string, 1
      optional :secret, :string, 2
      optional :region, :string, 3
      optional :endpoint, :string, 4
      optional :bucket, :string, 5
      optional :force_path_style, :bool, 6
      map :metadata, :string, :string, 7
      optional :tagging, :string, 8
    end
    add_message "livekit.GCPUpload" do
      optional :credentials, :string, 1
      optional :bucket, :string, 2
    end
    add_message "livekit.AzureBlobUpload" do
      optional :account_name, :string, 1
      optional :account_key, :string, 2
      optional :container_name, :string, 3
    end
    add_message "livekit.AliOSSUpload" do
      optional :access_key, :string, 1
      optional :secret, :string, 2
      optional :region, :string, 3
      optional :endpoint, :string, 4
      optional :bucket, :string, 5
    end
    add_message "livekit.StreamOutput" do
      optional :protocol, :enum, 1, "livekit.StreamProtocol"
      repeated :urls, :string, 2
    end
    add_message "livekit.EncodingOptions" do
      optional :width, :int32, 1
      optional :height, :int32, 2
      optional :depth, :int32, 3
      optional :framerate, :int32, 4
      optional :audio_codec, :enum, 5, "livekit.AudioCodec"
      optional :audio_bitrate, :int32, 6
      optional :audio_frequency, :int32, 7
      optional :video_codec, :enum, 8, "livekit.VideoCodec"
      optional :video_bitrate, :int32, 9
      optional :key_frame_interval, :double, 10
    end
    add_message "livekit.UpdateLayoutRequest" do
      optional :egress_id, :string, 1
      optional :layout, :string, 2
    end
    add_message "livekit.UpdateStreamRequest" do
      optional :egress_id, :string, 1
      repeated :add_output_urls, :string, 2
      repeated :remove_output_urls, :string, 3
    end
    add_message "livekit.ListEgressRequest" do
      optional :room_name, :string, 1
      optional :egress_id, :string, 2
      optional :active, :bool, 3
    end
    add_message "livekit.ListEgressResponse" do
      repeated :items, :message, 1, "livekit.EgressInfo"
    end
    add_message "livekit.StopEgressRequest" do
      optional :egress_id, :string, 1
    end
    add_message "livekit.EgressInfo" do
      optional :egress_id, :string, 1
      optional :room_id, :string, 2
      optional :room_name, :string, 13
      optional :status, :enum, 3, "livekit.EgressStatus"
      optional :started_at, :int64, 10
      optional :ended_at, :int64, 11
      optional :error, :string, 9
      repeated :stream_results, :message, 15, "livekit.StreamInfo"
      repeated :file_results, :message, 16, "livekit.FileInfo"
      repeated :segment_results, :message, 17, "livekit.SegmentsInfo"
      oneof :request do
        optional :room_composite, :message, 4, "livekit.RoomCompositeEgressRequest"
        optional :track_composite, :message, 5, "livekit.TrackCompositeEgressRequest"
        optional :track, :message, 6, "livekit.TrackEgressRequest"
        optional :web, :message, 14, "livekit.WebEgressRequest"
      end
      oneof :result do
        optional :stream, :message, 7, "livekit.StreamInfoList"
        optional :file, :message, 8, "livekit.FileInfo"
        optional :segments, :message, 12, "livekit.SegmentsInfo"
      end
    end
    add_message "livekit.StreamInfoList" do
      repeated :info, :message, 1, "livekit.StreamInfo"
    end
    add_message "livekit.StreamInfo" do
      optional :url, :string, 1
      optional :started_at, :int64, 2
      optional :ended_at, :int64, 3
      optional :duration, :int64, 4
      optional :status, :enum, 5, "livekit.StreamInfo.Status"
      optional :error, :string, 6
    end
    add_enum "livekit.StreamInfo.Status" do
      value :ACTIVE, 0
      value :FINISHED, 1
      value :FAILED, 2
    end
    add_message "livekit.FileInfo" do
      optional :filename, :string, 1
      optional :started_at, :int64, 2
      optional :ended_at, :int64, 3
      optional :duration, :int64, 6
      optional :size, :int64, 4
      optional :location, :string, 5
    end
    add_message "livekit.SegmentsInfo" do
      optional :playlist_name, :string, 1
      optional :duration, :int64, 2
      optional :size, :int64, 3
      optional :playlist_location, :string, 4
      optional :segment_count, :int64, 5
      optional :started_at, :int64, 6
      optional :ended_at, :int64, 7
    end
    add_message "livekit.AutoTrackEgress" do
      optional :filepath, :string, 1
      optional :disable_manifest, :bool, 5
      oneof :output do
        optional :s3, :message, 2, "livekit.S3Upload"
        optional :gcp, :message, 3, "livekit.GCPUpload"
        optional :azure, :message, 4, "livekit.AzureBlobUpload"
      end
    end
    add_enum "livekit.EncodedFileType" do
      value :DEFAULT_FILETYPE, 0
      value :MP4, 1
      value :OGG, 2
    end
    add_enum "livekit.SegmentedFileProtocol" do
      value :DEFAULT_SEGMENTED_FILE_PROTOCOL, 0
      value :HLS_PROTOCOL, 1
    end
    add_enum "livekit.SegmentedFileSuffix" do
      value :INDEX, 0
      value :TIMESTAMP, 1
    end
    add_enum "livekit.StreamProtocol" do
      value :DEFAULT_PROTOCOL, 0
      value :RTMP, 1
    end
    add_enum "livekit.EncodingOptionsPreset" do
      value :H264_720P_30, 0
      value :H264_720P_60, 1
      value :H264_1080P_30, 2
      value :H264_1080P_60, 3
      value :PORTRAIT_H264_720P_30, 4
      value :PORTRAIT_H264_720P_60, 5
      value :PORTRAIT_H264_1080P_30, 6
      value :PORTRAIT_H264_1080P_60, 7
    end
    add_enum "livekit.EgressStatus" do
      value :EGRESS_STARTING, 0
      value :EGRESS_ACTIVE, 1
      value :EGRESS_ENDING, 2
      value :EGRESS_COMPLETE, 3
      value :EGRESS_FAILED, 4
      value :EGRESS_ABORTED, 5
      value :EGRESS_LIMIT_REACHED, 6
    end
  end
end

module LiveKit
  module Proto
    RoomCompositeEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.RoomCompositeEgressRequest").msgclass
    WebEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.WebEgressRequest").msgclass
    TrackCompositeEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.TrackCompositeEgressRequest").msgclass
    TrackEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.TrackEgressRequest").msgclass
    EncodedFileOutput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EncodedFileOutput").msgclass
    SegmentedFileOutput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.SegmentedFileOutput").msgclass
    DirectFileOutput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.DirectFileOutput").msgclass
    S3Upload = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.S3Upload").msgclass
    GCPUpload = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.GCPUpload").msgclass
    AzureBlobUpload = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.AzureBlobUpload").msgclass
    AliOSSUpload = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.AliOSSUpload").msgclass
    StreamOutput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.StreamOutput").msgclass
    EncodingOptions = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EncodingOptions").msgclass
    UpdateLayoutRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.UpdateLayoutRequest").msgclass
    UpdateStreamRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.UpdateStreamRequest").msgclass
    ListEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.ListEgressRequest").msgclass
    ListEgressResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.ListEgressResponse").msgclass
    StopEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.StopEgressRequest").msgclass
    EgressInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EgressInfo").msgclass
    StreamInfoList = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.StreamInfoList").msgclass
    StreamInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.StreamInfo").msgclass
    StreamInfo::Status = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.StreamInfo.Status").enummodule
    FileInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.FileInfo").msgclass
    SegmentsInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.SegmentsInfo").msgclass
    AutoTrackEgress = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.AutoTrackEgress").msgclass
    EncodedFileType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EncodedFileType").enummodule
    SegmentedFileProtocol = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.SegmentedFileProtocol").enummodule
    SegmentedFileSuffix = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.SegmentedFileSuffix").enummodule
    StreamProtocol = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.StreamProtocol").enummodule
    EncodingOptionsPreset = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EncodingOptionsPreset").enummodule
    EgressStatus = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EgressStatus").enummodule
  end
end
