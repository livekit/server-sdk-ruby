require "livekit/proto/livekit_connector_twirp"
require "livekit/auth_mixin"
require 'livekit/utils'
require 'livekit/failover'
require 'livekit/dial_timeout'

module LiveKit
  # Client for LiveKit's Connector service, bridging WhatsApp and Twilio calls
  # into LiveKit rooms.
  #
  # The request types carry many fields, so each method takes a fully-built
  # protobuf request and returns the protobuf response.
  class ConnectorServiceClient < Twirp::Client
    client_for Proto::ConnectorService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil, token: nil, failover: true)
      super(LiveKit::Failover.connection(base_url, failover))
      @api_key = api_key
      @api_secret = api_secret
      @token = token
    end

    # Initiates an outbound WhatsApp call.
    # @param request [Proto::DialWhatsAppCallRequest]
    # @return [Proto::DialWhatsAppCallResponse]
    def dial_whatsapp_call(request)
      rpc!(
        :DialWhatsAppCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end

    # Accepts an inbound WhatsApp call.
    # @param request [Proto::AcceptWhatsAppCallRequest]
    # @param timeout [Numeric, nil] optional request timeout in seconds. When the
    #   request waits for the inbound party to join, it defaults to the standard
    #   ring window.
    # @return [Proto::AcceptWhatsAppCallResponse]
    def accept_whatsapp_call(request, timeout: nil)
      headers = auth_header(video_grant: VideoGrant.new(roomCreate: true))
      # Waiting for the inbound party to join can block, so default the request
      # timeout to the standard ring window; otherwise honor any user timeout.
      if request.wait_until_answered
        headers[Failover::TIMEOUT_HEADER] = (timeout || DialTimeout::DEFAULT_RINGING_TIMEOUT).to_s
      elsif timeout
        headers[Failover::TIMEOUT_HEADER] = timeout.to_s
      end
      rpc!(:AcceptWhatsAppCall, request, headers: headers)
    end

    # Connects an established WhatsApp call (used for business-initiated calls).
    # @param request [Proto::ConnectWhatsAppCallRequest]
    # @return [Proto::ConnectWhatsAppCallResponse]
    def connect_whatsapp_call(request)
      rpc!(
        :ConnectWhatsAppCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end

    # Disconnects an active WhatsApp call.
    # @param request [Proto::DisconnectWhatsAppCallRequest]
    # @return [Proto::DisconnectWhatsAppCallResponse]
    def disconnect_whatsapp_call(request)
      rpc!(
        :DisconnectWhatsAppCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end

    # Connects a Twilio call to a LiveKit room.
    # @param request [Proto::ConnectTwilioCallRequest]
    # @return [Proto::ConnectTwilioCallResponse]
    def connect_twilio_call(request)
      rpc!(
        :ConnectTwilioCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end
  end
end
