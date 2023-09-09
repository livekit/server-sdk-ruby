# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: livekit_egress.proto

require 'google/protobuf'

require 'livekit_models_pb'


descriptor_data = "\n\x14livekit_egress.proto\x12\x07livekit\x1a\x14livekit_models.proto\"\xa0\x04\n\x1aRoomCompositeEgressRequest\x12\x11\n\troom_name\x18\x01 \x01(\t\x12\x0e\n\x06layout\x18\x02 \x01(\t\x12\x12\n\naudio_only\x18\x03 \x01(\x08\x12\x12\n\nvideo_only\x18\x04 \x01(\x08\x12\x17\n\x0f\x63ustom_base_url\x18\x05 \x01(\t\x12.\n\x04\x66ile\x18\x06 \x01(\x0b\x32\x1a.livekit.EncodedFileOutputB\x02\x18\x01H\x00\x12+\n\x06stream\x18\x07 \x01(\x0b\x32\x15.livekit.StreamOutputB\x02\x18\x01H\x00\x12\x34\n\x08segments\x18\n \x01(\x0b\x32\x1c.livekit.SegmentedFileOutputB\x02\x18\x01H\x00\x12\x30\n\x06preset\x18\x08 \x01(\x0e\x32\x1e.livekit.EncodingOptionsPresetH\x01\x12,\n\x08\x61\x64vanced\x18\t \x01(\x0b\x32\x18.livekit.EncodingOptionsH\x01\x12\x30\n\x0c\x66ile_outputs\x18\x0b \x03(\x0b\x32\x1a.livekit.EncodedFileOutput\x12-\n\x0estream_outputs\x18\x0c \x03(\x0b\x32\x15.livekit.StreamOutput\x12\x35\n\x0fsegment_outputs\x18\r \x03(\x0b\x32\x1c.livekit.SegmentedFileOutputB\x08\n\x06outputB\t\n\x07options\"\x83\x04\n\x10WebEgressRequest\x12\x0b\n\x03url\x18\x01 \x01(\t\x12\x12\n\naudio_only\x18\x02 \x01(\x08\x12\x12\n\nvideo_only\x18\x03 \x01(\x08\x12\x1a\n\x12\x61wait_start_signal\x18\x0c \x01(\x08\x12.\n\x04\x66ile\x18\x04 \x01(\x0b\x32\x1a.livekit.EncodedFileOutputB\x02\x18\x01H\x00\x12+\n\x06stream\x18\x05 \x01(\x0b\x32\x15.livekit.StreamOutputB\x02\x18\x01H\x00\x12\x34\n\x08segments\x18\x06 \x01(\x0b\x32\x1c.livekit.SegmentedFileOutputB\x02\x18\x01H\x00\x12\x30\n\x06preset\x18\x07 \x01(\x0e\x32\x1e.livekit.EncodingOptionsPresetH\x01\x12,\n\x08\x61\x64vanced\x18\x08 \x01(\x0b\x32\x18.livekit.EncodingOptionsH\x01\x12\x30\n\x0c\x66ile_outputs\x18\t \x03(\x0b\x32\x1a.livekit.EncodedFileOutput\x12-\n\x0estream_outputs\x18\n \x03(\x0b\x32\x15.livekit.StreamOutput\x12\x35\n\x0fsegment_outputs\x18\x0b \x03(\x0b\x32\x1c.livekit.SegmentedFileOutputB\x08\n\x06outputB\t\n\x07options\"\xd8\x02\n\x18ParticipantEgressRequest\x12\x11\n\troom_name\x18\x01 \x01(\t\x12\x10\n\x08identity\x18\x02 \x01(\t\x12\x14\n\x0cscreen_share\x18\x03 \x01(\x08\x12\x30\n\x06preset\x18\x04 \x01(\x0e\x32\x1e.livekit.EncodingOptionsPresetH\x00\x12,\n\x08\x61\x64vanced\x18\x05 \x01(\x0b\x32\x18.livekit.EncodingOptionsH\x00\x12\x30\n\x0c\x66ile_outputs\x18\x06 \x03(\x0b\x32\x1a.livekit.EncodedFileOutput\x12-\n\x0estream_outputs\x18\x07 \x03(\x0b\x32\x15.livekit.StreamOutput\x12\x35\n\x0fsegment_outputs\x18\x08 \x03(\x0b\x32\x1c.livekit.SegmentedFileOutputB\t\n\x07options\"\x80\x04\n\x1bTrackCompositeEgressRequest\x12\x11\n\troom_name\x18\x01 \x01(\t\x12\x16\n\x0e\x61udio_track_id\x18\x02 \x01(\t\x12\x16\n\x0evideo_track_id\x18\x03 \x01(\t\x12.\n\x04\x66ile\x18\x04 \x01(\x0b\x32\x1a.livekit.EncodedFileOutputB\x02\x18\x01H\x00\x12+\n\x06stream\x18\x05 \x01(\x0b\x32\x15.livekit.StreamOutputB\x02\x18\x01H\x00\x12\x34\n\x08segments\x18\x08 \x01(\x0b\x32\x1c.livekit.SegmentedFileOutputB\x02\x18\x01H\x00\x12\x30\n\x06preset\x18\x06 \x01(\x0e\x32\x1e.livekit.EncodingOptionsPresetH\x01\x12,\n\x08\x61\x64vanced\x18\x07 \x01(\x0b\x32\x18.livekit.EncodingOptionsH\x01\x12\x30\n\x0c\x66ile_outputs\x18\x0b \x03(\x0b\x32\x1a.livekit.EncodedFileOutput\x12-\n\x0estream_outputs\x18\x0c \x03(\x0b\x32\x15.livekit.StreamOutput\x12\x35\n\x0fsegment_outputs\x18\r \x03(\x0b\x32\x1c.livekit.SegmentedFileOutputB\x08\n\x06outputB\t\n\x07options\"\x87\x01\n\x12TrackEgressRequest\x12\x11\n\troom_name\x18\x01 \x01(\t\x12\x10\n\x08track_id\x18\x02 \x01(\t\x12)\n\x04\x66ile\x18\x03 \x01(\x0b\x32\x19.livekit.DirectFileOutputH\x00\x12\x17\n\rwebsocket_url\x18\x04 \x01(\tH\x00\x42\x08\n\x06output\"\x8e\x02\n\x11\x45ncodedFileOutput\x12+\n\tfile_type\x18\x01 \x01(\x0e\x32\x18.livekit.EncodedFileType\x12\x10\n\x08\x66ilepath\x18\x02 \x01(\t\x12\x18\n\x10\x64isable_manifest\x18\x06 \x01(\x08\x12\x1f\n\x02s3\x18\x03 \x01(\x0b\x32\x11.livekit.S3UploadH\x00\x12!\n\x03gcp\x18\x04 \x01(\x0b\x32\x12.livekit.GCPUploadH\x00\x12)\n\x05\x61zure\x18\x05 \x01(\x0b\x32\x18.livekit.AzureBlobUploadH\x00\x12\'\n\x06\x61liOSS\x18\x07 \x01(\x0b\x32\x15.livekit.AliOSSUploadH\x00\x42\x08\n\x06output\"\xa0\x03\n\x13SegmentedFileOutput\x12\x30\n\x08protocol\x18\x01 \x01(\x0e\x32\x1e.livekit.SegmentedFileProtocol\x12\x17\n\x0f\x66ilename_prefix\x18\x02 \x01(\t\x12\x15\n\rplaylist_name\x18\x03 \x01(\t\x12\x1a\n\x12live_playlist_name\x18\x0b \x01(\t\x12\x18\n\x10segment_duration\x18\x04 \x01(\r\x12\x35\n\x0f\x66ilename_suffix\x18\n \x01(\x0e\x32\x1c.livekit.SegmentedFileSuffix\x12\x18\n\x10\x64isable_manifest\x18\x08 \x01(\x08\x12\x1f\n\x02s3\x18\x05 \x01(\x0b\x32\x11.livekit.S3UploadH\x00\x12!\n\x03gcp\x18\x06 \x01(\x0b\x32\x12.livekit.GCPUploadH\x00\x12)\n\x05\x61zure\x18\x07 \x01(\x0b\x32\x18.livekit.AzureBlobUploadH\x00\x12\'\n\x06\x61liOSS\x18\t \x01(\x0b\x32\x15.livekit.AliOSSUploadH\x00\x42\x08\n\x06output\"\xe0\x01\n\x10\x44irectFileOutput\x12\x10\n\x08\x66ilepath\x18\x01 \x01(\t\x12\x18\n\x10\x64isable_manifest\x18\x05 \x01(\x08\x12\x1f\n\x02s3\x18\x02 \x01(\x0b\x32\x11.livekit.S3UploadH\x00\x12!\n\x03gcp\x18\x03 \x01(\x0b\x32\x12.livekit.GCPUploadH\x00\x12)\n\x05\x61zure\x18\x04 \x01(\x0b\x32\x18.livekit.AzureBlobUploadH\x00\x12\'\n\x06\x61liOSS\x18\x06 \x01(\x0b\x32\x15.livekit.AliOSSUploadH\x00\x42\x08\n\x06output\"\xef\x01\n\x08S3Upload\x12\x12\n\naccess_key\x18\x01 \x01(\t\x12\x0e\n\x06secret\x18\x02 \x01(\t\x12\x0e\n\x06region\x18\x03 \x01(\t\x12\x10\n\x08\x65ndpoint\x18\x04 \x01(\t\x12\x0e\n\x06\x62ucket\x18\x05 \x01(\t\x12\x18\n\x10\x66orce_path_style\x18\x06 \x01(\x08\x12\x31\n\x08metadata\x18\x07 \x03(\x0b\x32\x1f.livekit.S3Upload.MetadataEntry\x12\x0f\n\x07tagging\x18\x08 \x01(\t\x1a/\n\rMetadataEntry\x12\x0b\n\x03key\x18\x01 \x01(\t\x12\r\n\x05value\x18\x02 \x01(\t:\x02\x38\x01\"0\n\tGCPUpload\x12\x13\n\x0b\x63redentials\x18\x01 \x01(\t\x12\x0e\n\x06\x62ucket\x18\x02 \x01(\t\"T\n\x0f\x41zureBlobUpload\x12\x14\n\x0c\x61\x63\x63ount_name\x18\x01 \x01(\t\x12\x13\n\x0b\x61\x63\x63ount_key\x18\x02 \x01(\t\x12\x16\n\x0e\x63ontainer_name\x18\x03 \x01(\t\"d\n\x0c\x41liOSSUpload\x12\x12\n\naccess_key\x18\x01 \x01(\t\x12\x0e\n\x06secret\x18\x02 \x01(\t\x12\x0e\n\x06region\x18\x03 \x01(\t\x12\x10\n\x08\x65ndpoint\x18\x04 \x01(\t\x12\x0e\n\x06\x62ucket\x18\x05 \x01(\t\"G\n\x0cStreamOutput\x12)\n\x08protocol\x18\x01 \x01(\x0e\x32\x17.livekit.StreamProtocol\x12\x0c\n\x04urls\x18\x02 \x03(\t\"\x89\x02\n\x0f\x45ncodingOptions\x12\r\n\x05width\x18\x01 \x01(\x05\x12\x0e\n\x06height\x18\x02 \x01(\x05\x12\r\n\x05\x64\x65pth\x18\x03 \x01(\x05\x12\x11\n\tframerate\x18\x04 \x01(\x05\x12(\n\x0b\x61udio_codec\x18\x05 \x01(\x0e\x32\x13.livekit.AudioCodec\x12\x15\n\raudio_bitrate\x18\x06 \x01(\x05\x12\x17\n\x0f\x61udio_frequency\x18\x07 \x01(\x05\x12(\n\x0bvideo_codec\x18\x08 \x01(\x0e\x32\x13.livekit.VideoCodec\x12\x15\n\rvideo_bitrate\x18\t \x01(\x05\x12\x1a\n\x12key_frame_interval\x18\n \x01(\x01\"8\n\x13UpdateLayoutRequest\x12\x11\n\tegress_id\x18\x01 \x01(\t\x12\x0e\n\x06layout\x18\x02 \x01(\t\"]\n\x13UpdateStreamRequest\x12\x11\n\tegress_id\x18\x01 \x01(\t\x12\x17\n\x0f\x61\x64\x64_output_urls\x18\x02 \x03(\t\x12\x1a\n\x12remove_output_urls\x18\x03 \x03(\t\"I\n\x11ListEgressRequest\x12\x11\n\troom_name\x18\x01 \x01(\t\x12\x11\n\tegress_id\x18\x02 \x01(\t\x12\x0e\n\x06\x61\x63tive\x18\x03 \x01(\x08\"8\n\x12ListEgressResponse\x12\"\n\x05items\x18\x01 \x03(\x0b\x32\x13.livekit.EgressInfo\"&\n\x11StopEgressRequest\x12\x11\n\tegress_id\x18\x01 \x01(\t\"\xe5\x05\n\nEgressInfo\x12\x11\n\tegress_id\x18\x01 \x01(\t\x12\x0f\n\x07room_id\x18\x02 \x01(\t\x12\x11\n\troom_name\x18\r \x01(\t\x12%\n\x06status\x18\x03 \x01(\x0e\x32\x15.livekit.EgressStatus\x12\x12\n\nstarted_at\x18\n \x01(\x03\x12\x10\n\x08\x65nded_at\x18\x0b \x01(\x03\x12\x12\n\nupdated_at\x18\x12 \x01(\x03\x12\r\n\x05\x65rror\x18\t \x01(\t\x12=\n\x0eroom_composite\x18\x04 \x01(\x0b\x32#.livekit.RoomCompositeEgressRequestH\x00\x12(\n\x03web\x18\x0e \x01(\x0b\x32\x19.livekit.WebEgressRequestH\x00\x12\x38\n\x0bparticipant\x18\x13 \x01(\x0b\x32!.livekit.ParticipantEgressRequestH\x00\x12?\n\x0ftrack_composite\x18\x05 \x01(\x0b\x32$.livekit.TrackCompositeEgressRequestH\x00\x12,\n\x05track\x18\x06 \x01(\x0b\x32\x1b.livekit.TrackEgressRequestH\x00\x12-\n\x06stream\x18\x07 \x01(\x0b\x32\x17.livekit.StreamInfoListB\x02\x18\x01H\x01\x12%\n\x04\x66ile\x18\x08 \x01(\x0b\x32\x11.livekit.FileInfoB\x02\x18\x01H\x01\x12-\n\x08segments\x18\x0c \x01(\x0b\x32\x15.livekit.SegmentsInfoB\x02\x18\x01H\x01\x12+\n\x0estream_results\x18\x0f \x03(\x0b\x32\x13.livekit.StreamInfo\x12\'\n\x0c\x66ile_results\x18\x10 \x03(\x0b\x32\x11.livekit.FileInfo\x12.\n\x0fsegment_results\x18\x11 \x03(\x0b\x32\x15.livekit.SegmentsInfoB\t\n\x07requestB\x08\n\x06result\"7\n\x0eStreamInfoList\x12!\n\x04info\x18\x01 \x03(\x0b\x32\x13.livekit.StreamInfo:\x02\x18\x01\"\xbc\x01\n\nStreamInfo\x12\x0b\n\x03url\x18\x01 \x01(\t\x12\x12\n\nstarted_at\x18\x02 \x01(\x03\x12\x10\n\x08\x65nded_at\x18\x03 \x01(\x03\x12\x10\n\x08\x64uration\x18\x04 \x01(\x03\x12*\n\x06status\x18\x05 \x01(\x0e\x32\x1a.livekit.StreamInfo.Status\x12\r\n\x05\x65rror\x18\x06 \x01(\t\".\n\x06Status\x12\n\n\x06\x41\x43TIVE\x10\x00\x12\x0c\n\x08\x46INISHED\x10\x01\x12\n\n\x06\x46\x41ILED\x10\x02\"t\n\x08\x46ileInfo\x12\x10\n\x08\x66ilename\x18\x01 \x01(\t\x12\x12\n\nstarted_at\x18\x02 \x01(\x03\x12\x10\n\x08\x65nded_at\x18\x03 \x01(\x03\x12\x10\n\x08\x64uration\x18\x06 \x01(\x03\x12\x0c\n\x04size\x18\x04 \x01(\x03\x12\x10\n\x08location\x18\x05 \x01(\t\"\xd9\x01\n\x0cSegmentsInfo\x12\x15\n\rplaylist_name\x18\x01 \x01(\t\x12\x1a\n\x12live_playlist_name\x18\x08 \x01(\t\x12\x10\n\x08\x64uration\x18\x02 \x01(\x03\x12\x0c\n\x04size\x18\x03 \x01(\x03\x12\x19\n\x11playlist_location\x18\x04 \x01(\t\x12\x1e\n\x16live_playlist_location\x18\t \x01(\t\x12\x15\n\rsegment_count\x18\x05 \x01(\x03\x12\x12\n\nstarted_at\x18\x06 \x01(\x03\x12\x10\n\x08\x65nded_at\x18\x07 \x01(\x03\"\xeb\x01\n\x15\x41utoParticipantEgress\x12\x30\n\x06preset\x18\x01 \x01(\x0e\x32\x1e.livekit.EncodingOptionsPresetH\x00\x12,\n\x08\x61\x64vanced\x18\x02 \x01(\x0b\x32\x18.livekit.EncodingOptionsH\x00\x12\x30\n\x0c\x66ile_outputs\x18\x03 \x03(\x0b\x32\x1a.livekit.EncodedFileOutput\x12\x35\n\x0fsegment_outputs\x18\x04 \x03(\x0b\x32\x1c.livekit.SegmentedFileOutputB\t\n\x07options\"\xb6\x01\n\x0f\x41utoTrackEgress\x12\x10\n\x08\x66ilepath\x18\x01 \x01(\t\x12\x18\n\x10\x64isable_manifest\x18\x05 \x01(\x08\x12\x1f\n\x02s3\x18\x02 \x01(\x0b\x32\x11.livekit.S3UploadH\x00\x12!\n\x03gcp\x18\x03 \x01(\x0b\x32\x12.livekit.GCPUploadH\x00\x12)\n\x05\x61zure\x18\x04 \x01(\x0b\x32\x18.livekit.AzureBlobUploadH\x00\x42\x08\n\x06output*9\n\x0f\x45ncodedFileType\x12\x14\n\x10\x44\x45\x46\x41ULT_FILETYPE\x10\x00\x12\x07\n\x03MP4\x10\x01\x12\x07\n\x03OGG\x10\x02*N\n\x15SegmentedFileProtocol\x12#\n\x1f\x44\x45\x46\x41ULT_SEGMENTED_FILE_PROTOCOL\x10\x00\x12\x10\n\x0cHLS_PROTOCOL\x10\x01*/\n\x13SegmentedFileSuffix\x12\t\n\x05INDEX\x10\x00\x12\r\n\tTIMESTAMP\x10\x01*0\n\x0eStreamProtocol\x12\x14\n\x10\x44\x45\x46\x41ULT_PROTOCOL\x10\x00\x12\x08\n\x04RTMP\x10\x01*\xcf\x01\n\x15\x45ncodingOptionsPreset\x12\x10\n\x0cH264_720P_30\x10\x00\x12\x10\n\x0cH264_720P_60\x10\x01\x12\x11\n\rH264_1080P_30\x10\x02\x12\x11\n\rH264_1080P_60\x10\x03\x12\x19\n\x15PORTRAIT_H264_720P_30\x10\x04\x12\x19\n\x15PORTRAIT_H264_720P_60\x10\x05\x12\x1a\n\x16PORTRAIT_H264_1080P_30\x10\x06\x12\x1a\n\x16PORTRAIT_H264_1080P_60\x10\x07*\x9f\x01\n\x0c\x45gressStatus\x12\x13\n\x0f\x45GRESS_STARTING\x10\x00\x12\x11\n\rEGRESS_ACTIVE\x10\x01\x12\x11\n\rEGRESS_ENDING\x10\x02\x12\x13\n\x0f\x45GRESS_COMPLETE\x10\x03\x12\x11\n\rEGRESS_FAILED\x10\x04\x12\x12\n\x0e\x45GRESS_ABORTED\x10\x05\x12\x18\n\x14\x45GRESS_LIMIT_REACHED\x10\x06\x32\x9c\x05\n\x06\x45gress\x12T\n\x18StartRoomCompositeEgress\x12#.livekit.RoomCompositeEgressRequest\x1a\x13.livekit.EgressInfo\x12@\n\x0eStartWebEgress\x12\x19.livekit.WebEgressRequest\x1a\x13.livekit.EgressInfo\x12P\n\x16StartParticipantEgress\x12!.livekit.ParticipantEgressRequest\x1a\x13.livekit.EgressInfo\x12V\n\x19StartTrackCompositeEgress\x12$.livekit.TrackCompositeEgressRequest\x1a\x13.livekit.EgressInfo\x12\x44\n\x10StartTrackEgress\x12\x1b.livekit.TrackEgressRequest\x1a\x13.livekit.EgressInfo\x12\x41\n\x0cUpdateLayout\x12\x1c.livekit.UpdateLayoutRequest\x1a\x13.livekit.EgressInfo\x12\x41\n\x0cUpdateStream\x12\x1c.livekit.UpdateStreamRequest\x1a\x13.livekit.EgressInfo\x12\x45\n\nListEgress\x12\x1a.livekit.ListEgressRequest\x1a\x1b.livekit.ListEgressResponse\x12=\n\nStopEgress\x12\x1a.livekit.StopEgressRequest\x1a\x13.livekit.EgressInfoBFZ#github.com/livekit/protocol/livekit\xaa\x02\rLiveKit.Proto\xea\x02\x0eLiveKit::Protob\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool

begin
  pool.add_serialized_file(descriptor_data)
rescue TypeError => e
  # Compatibility code: will be removed in the next major version.
  require 'google/protobuf/descriptor_pb'
  parsed = Google::Protobuf::FileDescriptorProto.decode(descriptor_data)
  parsed.clear_dependency
  serialized = parsed.class.encode(parsed)
  file = pool.add_serialized_file(serialized)
  warn "Warning: Protobuf detected an import path issue while loading generated file #{__FILE__}"
  imports = [
  ]
  imports.each do |type_name, expected_filename|
    import_file = pool.lookup(type_name).file_descriptor
    if import_file.name != expected_filename
      warn "- #{file.name} imports #{expected_filename}, but that import was loaded as #{import_file.name}"
    end
  end
  warn "Each proto file must use a consistent fully-qualified name."
  warn "This will become an error in the next major version."
end

module LiveKit
  module Proto
    RoomCompositeEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.RoomCompositeEgressRequest").msgclass
    WebEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.WebEgressRequest").msgclass
    ParticipantEgressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.ParticipantEgressRequest").msgclass
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
    AutoParticipantEgress = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.AutoParticipantEgress").msgclass
    AutoTrackEgress = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.AutoTrackEgress").msgclass
    EncodedFileType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EncodedFileType").enummodule
    SegmentedFileProtocol = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.SegmentedFileProtocol").enummodule
    SegmentedFileSuffix = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.SegmentedFileSuffix").enummodule
    StreamProtocol = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.StreamProtocol").enummodule
    EncodingOptionsPreset = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EncodingOptionsPreset").enummodule
    EgressStatus = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.EgressStatus").enummodule
  end
end
