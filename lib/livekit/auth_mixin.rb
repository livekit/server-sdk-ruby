# frozen_string_literal: true

module LiveKit
  # Create authenticated headers when keys are provided
  module AuthMixin
    def auth_header(
      video_grant,
      sip_grant: nil
    )
      headers = {}
      t = ::LiveKit::AccessToken.new(api_key: @api_key, api_secret: @api_secret)
      t.add_grant(video_grant)
      if sip_grant != nil
        t.add_sip_grant(sip_grant)
      end
      headers["Authorization"] = "Bearer #{t.to_jwt}"
      headers["User-Agent"] = "LiveKit Ruby SDK"
      headers
    end
  end
end
