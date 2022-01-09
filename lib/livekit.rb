# frozen_string_literal: true

require "livekit/access_token"
require "livekit/grants"
require "livekit/token_verifier"
require "livekit/utils"
require "livekit/version"

# required since generated protobufs does use `require` instead of `require_relative`
FOLDER = Pathname.new(File.expand_path("lib/livekit/proto"))
$LOAD_PATH.unshift(FOLDER.to_s)
require "livekit/room_service_client"
