# frozen_string_literal: true

require 'livekit/version'

module Livekit
  autoload(:Proto, File.expand_path('livekit/proto.rb', __dir__))
  autoload(:AccessToken, File.expand_path('livekit/access_token.rb', __dir__))
end
