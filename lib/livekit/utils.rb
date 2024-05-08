# frozen_string_literal: true

module LiveKit
  module Utils
    # Utility function to convert WebSocket URLs to HTTP URLs
    def to_http_url(url)
      if url.start_with?("ws")
        # Replace 'ws' prefix with 'http'
        url.sub(/^ws/, "http")
      else
        url
      end
    end
    module_function :to_http_url

    module StringifyKeysRefinement
      refine Hash do
        def stringify_keys
          transform_keys(&:to_s).transform_values do |value|
            value.is_a?(Hash) ? value.stringify_keys : value
          end
        end
      end
    end
  end
end