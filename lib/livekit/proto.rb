# frozen_string_literal: true

module Livekit
  module Proto
    PATH = Pathname.new(File.expand_path(__dir__ + '/proto'))

    def self.initialize_proto!
      $LOAD_PATH.unshift(PATH)
      PATH.children.sort.each { |proto_file| require proto_file }
    end
  end
end
