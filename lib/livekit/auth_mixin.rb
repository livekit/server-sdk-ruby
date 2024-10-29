# frozen_string_literal: true

module LiveKit
  # Create authenticated headers when keys are provided
  module AuthMixin
    def auth_header(
      video_grant: nil,
      sip_grant: nil
    )
      headers = {}
      t = ::LiveKit::AccessToken.new(api_key: @api_key, api_secret: @api_secret)
      if video_grant != nil
        t.set_sip_grant(video_grant)
      end
      if sip_grant != nil
        t.set_sip_grant(sip_grant)
      end
      headers["Authorization"] = "Bearer #{t.to_jwt}"
      headers["User-Agent"] = "LiveKit Ruby SDK"
      headers
    end
  end
end
