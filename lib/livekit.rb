# frozen_string_literal: true

require 'livekit/version'
require 'livekit/access_token'

module Livekit
  autoload(:Proto, File.expand_path('livekit/proto.rb', __dir__))
end
