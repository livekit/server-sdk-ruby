# frozen_string_literal: true

module LiveKit
  module Utils
    def to_http_url(url)
      if url.start_with?("ws")
        # replace ws prefix to http
        return url.sub(/^ws/, "http")
      else
        return url
      end
    end

    module_function :to_http_url
  end
end
# convert websocket urls to http
