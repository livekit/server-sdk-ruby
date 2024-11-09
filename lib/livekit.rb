# frozen_string_literal: true

require "livekit/access_token"
require "livekit/utils"
require "livekit/grants"
require "livekit/token_verifier"
require "livekit/version"

# required since generated protobufs does use `require` instead of `require_relative`
$LOAD_PATH.unshift(File.expand_path("livekit/proto", __dir__))
require "livekit/room_service_client"
require "livekit/egress_service_client"
require "livekit/ingress_service_client"
require "livekit/sip_service_client"
require "livekit/agent_dispatch_service_client"
