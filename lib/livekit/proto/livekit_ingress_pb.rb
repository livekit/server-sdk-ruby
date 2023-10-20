# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: livekit_ingress.proto

require 'google/protobuf'

require 'livekit_models_pb'


descriptor_data = "\n\x15livekit_ingress.proto\x12\x07livekit\x1a\x14livekit_models.proto\"\x9d\x02\n\x14\x43reateIngressRequest\x12)\n\ninput_type\x18\x01 \x01(\x0e\x32\x15.livekit.IngressInput\x12\x0b\n\x03url\x18\t \x01(\t\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x11\n\troom_name\x18\x03 \x01(\t\x12\x1c\n\x14participant_identity\x18\x04 \x01(\t\x12\x18\n\x10participant_name\x18\x05 \x01(\t\x12\x1a\n\x12\x62ypass_transcoding\x18\x08 \x01(\x08\x12+\n\x05\x61udio\x18\x06 \x01(\x0b\x32\x1c.livekit.IngressAudioOptions\x12+\n\x05video\x18\x07 \x01(\x0b\x32\x1c.livekit.IngressVideoOptions\"\xcd\x01\n\x13IngressAudioOptions\x12\x0c\n\x04name\x18\x01 \x01(\t\x12$\n\x06source\x18\x02 \x01(\x0e\x32\x14.livekit.TrackSource\x12\x35\n\x06preset\x18\x03 \x01(\x0e\x32#.livekit.IngressAudioEncodingPresetH\x00\x12\x37\n\x07options\x18\x04 \x01(\x0b\x32$.livekit.IngressAudioEncodingOptionsH\x00\x42\x12\n\x10\x65ncoding_options\"\xcd\x01\n\x13IngressVideoOptions\x12\x0c\n\x04name\x18\x01 \x01(\t\x12$\n\x06source\x18\x02 \x01(\x0e\x32\x14.livekit.TrackSource\x12\x35\n\x06preset\x18\x03 \x01(\x0e\x32#.livekit.IngressVideoEncodingPresetH\x00\x12\x37\n\x07options\x18\x04 \x01(\x0b\x32$.livekit.IngressVideoEncodingOptionsH\x00\x42\x12\n\x10\x65ncoding_options\"\x7f\n\x1bIngressAudioEncodingOptions\x12(\n\x0b\x61udio_codec\x18\x01 \x01(\x0e\x32\x13.livekit.AudioCodec\x12\x0f\n\x07\x62itrate\x18\x02 \x01(\r\x12\x13\n\x0b\x64isable_dtx\x18\x03 \x01(\x08\x12\x10\n\x08\x63hannels\x18\x04 \x01(\r\"\x80\x01\n\x1bIngressVideoEncodingOptions\x12(\n\x0bvideo_codec\x18\x01 \x01(\x0e\x32\x13.livekit.VideoCodec\x12\x12\n\nframe_rate\x18\x02 \x01(\x01\x12#\n\x06layers\x18\x03 \x03(\x0b\x32\x13.livekit.VideoLayer\"\xf4\x02\n\x0bIngressInfo\x12\x12\n\ningress_id\x18\x01 \x01(\t\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x12\n\nstream_key\x18\x03 \x01(\t\x12\x0b\n\x03url\x18\x04 \x01(\t\x12)\n\ninput_type\x18\x05 \x01(\x0e\x32\x15.livekit.IngressInput\x12\x1a\n\x12\x62ypass_transcoding\x18\r \x01(\x08\x12+\n\x05\x61udio\x18\x06 \x01(\x0b\x32\x1c.livekit.IngressAudioOptions\x12+\n\x05video\x18\x07 \x01(\x0b\x32\x1c.livekit.IngressVideoOptions\x12\x11\n\troom_name\x18\x08 \x01(\t\x12\x1c\n\x14participant_identity\x18\t \x01(\t\x12\x18\n\x10participant_name\x18\n \x01(\t\x12\x10\n\x08reusable\x18\x0b \x01(\x08\x12$\n\x05state\x18\x0c \x01(\x0b\x32\x15.livekit.IngressState\"\x8a\x03\n\x0cIngressState\x12,\n\x06status\x18\x01 \x01(\x0e\x32\x1c.livekit.IngressState.Status\x12\r\n\x05\x65rror\x18\x02 \x01(\t\x12\'\n\x05video\x18\x03 \x01(\x0b\x32\x18.livekit.InputVideoState\x12\'\n\x05\x61udio\x18\x04 \x01(\x0b\x32\x18.livekit.InputAudioState\x12\x0f\n\x07room_id\x18\x05 \x01(\t\x12\x12\n\nstarted_at\x18\x07 \x01(\x03\x12\x10\n\x08\x65nded_at\x18\x08 \x01(\x03\x12\x13\n\x0bresource_id\x18\t \x01(\t\x12\"\n\x06tracks\x18\x06 \x03(\x0b\x32\x12.livekit.TrackInfo\"{\n\x06Status\x12\x15\n\x11\x45NDPOINT_INACTIVE\x10\x00\x12\x16\n\x12\x45NDPOINT_BUFFERING\x10\x01\x12\x17\n\x13\x45NDPOINT_PUBLISHING\x10\x02\x12\x12\n\x0e\x45NDPOINT_ERROR\x10\x03\x12\x15\n\x11\x45NDPOINT_COMPLETE\x10\x04\"o\n\x0fInputVideoState\x12\x11\n\tmime_type\x18\x01 \x01(\t\x12\x17\n\x0f\x61verage_bitrate\x18\x02 \x01(\r\x12\r\n\x05width\x18\x03 \x01(\r\x12\x0e\n\x06height\x18\x04 \x01(\r\x12\x11\n\tframerate\x18\x05 \x01(\x01\"d\n\x0fInputAudioState\x12\x11\n\tmime_type\x18\x01 \x01(\t\x12\x17\n\x0f\x61verage_bitrate\x18\x02 \x01(\r\x12\x10\n\x08\x63hannels\x18\x03 \x01(\r\x12\x13\n\x0bsample_rate\x18\x04 \x01(\r\"\x95\x02\n\x14UpdateIngressRequest\x12\x12\n\ningress_id\x18\x01 \x01(\t\x12\x0c\n\x04name\x18\x02 \x01(\t\x12\x11\n\troom_name\x18\x03 \x01(\t\x12\x1c\n\x14participant_identity\x18\x04 \x01(\t\x12\x18\n\x10participant_name\x18\x05 \x01(\t\x12\x1f\n\x12\x62ypass_transcoding\x18\x08 \x01(\x08H\x00\x88\x01\x01\x12+\n\x05\x61udio\x18\x06 \x01(\x0b\x32\x1c.livekit.IngressAudioOptions\x12+\n\x05video\x18\x07 \x01(\x0b\x32\x1c.livekit.IngressVideoOptionsB\x15\n\x13_bypass_transcoding\";\n\x12ListIngressRequest\x12\x11\n\troom_name\x18\x01 \x01(\t\x12\x12\n\ningress_id\x18\x02 \x01(\t\":\n\x13ListIngressResponse\x12#\n\x05items\x18\x01 \x03(\x0b\x32\x14.livekit.IngressInfo\"*\n\x14\x44\x65leteIngressRequest\x12\x12\n\ningress_id\x18\x01 \x01(\t*=\n\x0cIngressInput\x12\x0e\n\nRTMP_INPUT\x10\x00\x12\x0e\n\nWHIP_INPUT\x10\x01\x12\r\n\tURL_INPUT\x10\x02*I\n\x1aIngressAudioEncodingPreset\x12\x16\n\x12OPUS_STEREO_96KBPS\x10\x00\x12\x13\n\x0fOPUS_MONO_64KBS\x10\x01*\x84\x03\n\x1aIngressVideoEncodingPreset\x12\x1c\n\x18H264_720P_30FPS_3_LAYERS\x10\x00\x12\x1d\n\x19H264_1080P_30FPS_3_LAYERS\x10\x01\x12\x1c\n\x18H264_540P_25FPS_2_LAYERS\x10\x02\x12\x1b\n\x17H264_720P_30FPS_1_LAYER\x10\x03\x12\x1c\n\x18H264_1080P_30FPS_1_LAYER\x10\x04\x12(\n$H264_720P_30FPS_3_LAYERS_HIGH_MOTION\x10\x05\x12)\n%H264_1080P_30FPS_3_LAYERS_HIGH_MOTION\x10\x06\x12(\n$H264_540P_25FPS_2_LAYERS_HIGH_MOTION\x10\x07\x12\'\n#H264_720P_30FPS_1_LAYER_HIGH_MOTION\x10\x08\x12(\n$H264_1080P_30FPS_1_LAYER_HIGH_MOTION\x10\t2\xa5\x02\n\x07Ingress\x12\x44\n\rCreateIngress\x12\x1d.livekit.CreateIngressRequest\x1a\x14.livekit.IngressInfo\x12\x44\n\rUpdateIngress\x12\x1d.livekit.UpdateIngressRequest\x1a\x14.livekit.IngressInfo\x12H\n\x0bListIngress\x12\x1b.livekit.ListIngressRequest\x1a\x1c.livekit.ListIngressResponse\x12\x44\n\rDeleteIngress\x12\x1d.livekit.DeleteIngressRequest\x1a\x14.livekit.IngressInfoBFZ#github.com/livekit/protocol/livekit\xaa\x02\rLiveKit.Proto\xea\x02\x0eLiveKit::Protob\x06proto3"

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
    ["livekit.VideoLayer", "livekit_models.proto"],
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
    CreateIngressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.CreateIngressRequest").msgclass
    IngressAudioOptions = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressAudioOptions").msgclass
    IngressVideoOptions = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressVideoOptions").msgclass
    IngressAudioEncodingOptions = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressAudioEncodingOptions").msgclass
    IngressVideoEncodingOptions = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressVideoEncodingOptions").msgclass
    IngressInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressInfo").msgclass
    IngressState = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressState").msgclass
    IngressState::Status = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressState.Status").enummodule
    InputVideoState = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.InputVideoState").msgclass
    InputAudioState = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.InputAudioState").msgclass
    UpdateIngressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.UpdateIngressRequest").msgclass
    ListIngressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.ListIngressRequest").msgclass
    ListIngressResponse = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.ListIngressResponse").msgclass
    DeleteIngressRequest = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.DeleteIngressRequest").msgclass
    IngressInput = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressInput").enummodule
    IngressAudioEncodingPreset = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressAudioEncodingPreset").enummodule
    IngressVideoEncodingPreset = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("livekit.IngressVideoEncodingPreset").enummodule
  end
end
