# frozen_string_literal: true

module Livekit
  module Proto
    FOLDER = Pathname.new(File.expand_path('lib/livekit/proto'))

    def self.initialize_proto!
      $LOAD_PATH.unshift(FOLDER)
      FOLDER.children.sort.each { |proto_file| require proto_file }
    end
  end
end
