# frozen_string_literal: true

require 'livekit/version'

module Livekit
  autoload(:Proto, File.expand_path('livekit/proto.rb', __dir__))
  autoload(:AccessToken, File.expand_path('livekit/access_token.rb', __dir__))

  Proto.initialize_proto!

  class Client
    extend Forwardable

    room_methods = (Proto::RoomServiceClient.instance_methods - public_methods) - [:rpc]
    delegate room_methods => :@client

    def initialize(url)
      conn = Faraday.new(url: url) do |c|
        c.request :authorization, 'Bearer', LiveKit::AccessToken.new
      end

      @client = Proto::RoomServiceClient.new(conn)
    end
  end
end
