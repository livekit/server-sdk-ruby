# frozen_string_literal: true

require "livekit/errors"

module LiveKit
  # Shared behavior for the Twirp-based service clients: builds authenticated
  # request headers and issues RPCs that raise on error.
  module AuthMixin
    # Builds request headers. When a pre-signed token is set it is sent verbatim
    # (the caller is responsible for its grants); otherwise a token is signed per
    # call from the API key and secret.
    def auth_header(
      video_grant: nil,
      sip_grant: nil
    )
      headers = {}
      if @token
        headers["Authorization"] = "Bearer #{@token}"
        return headers
      end

      t = ::LiveKit::AccessToken.new(api_key: @api_key, api_secret: @api_secret)
      t.video_grant = video_grant if video_grant != nil
      t.sip_grant = sip_grant if sip_grant != nil
      headers["Authorization"] = "Bearer #{t.to_jwt}"
      headers
    end

    # Issues a Twirp RPC and returns the response message, raising a
    # {LiveKit::ServerError} (or {LiveKit::SipCallError}) on failure.
    def rpc!(rpc_method, input, headers:)
      resp = rpc(rpc_method, input, headers: headers)
      raise ::LiveKit::ServerError.from(resp.error) if resp.error

      resp.data
    end
  end
end
