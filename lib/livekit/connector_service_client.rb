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

    def initialize(base_url, api_key: nil, api_secret: nil, failover: true)
      super(LiveKit::Failover.connection(base_url, failover))
      @api_key = api_key
      @api_secret = api_secret
    end

    # Initiates an outbound WhatsApp call.
    # @param request [Proto::DialWhatsAppCallRequest]
    # @return [Proto::DialWhatsAppCallResponse]
    def dial_whatsapp_call(request)
      self.rpc(
        :DialWhatsAppCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end

    # Accepts an inbound WhatsApp call.
    # @param request [Proto::AcceptWhatsAppCallRequest]
    # @param timeout [Numeric, nil] optional request timeout in seconds. When the
    #   request waits for an answer, it defaults to a longer value (dialing takes
    #   time) and is raised, if needed, to stay above the request's ringing_timeout.
    # @return [Proto::AcceptWhatsAppCallResponse]
    def accept_whatsapp_call(request, timeout: nil)
      headers = auth_header(video_grant: VideoGrant.new(roomCreate: true))
      # When waiting for an answer, dialing takes longer than a normal request and
      # the request must outlast ringing; otherwise honor any user timeout.
      if request.wait_until_answered
        ringing = request.ringing_timeout&.seconds
        headers[Failover::TIMEOUT_HEADER] = DialTimeout.resolve(timeout, ringing).to_s
      elsif timeout
        headers[Failover::TIMEOUT_HEADER] = timeout.to_s
      end
      self.rpc(:AcceptWhatsAppCall, request, headers: headers)
    end

    # Connects an established WhatsApp call (used for business-initiated calls).
    # @param request [Proto::ConnectWhatsAppCallRequest]
    # @return [Proto::ConnectWhatsAppCallResponse]
    def connect_whatsapp_call(request)
      self.rpc(
        :ConnectWhatsAppCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end

    # Disconnects an active WhatsApp call.
    # @param request [Proto::DisconnectWhatsAppCallRequest]
    # @return [Proto::DisconnectWhatsAppCallResponse]
    def disconnect_whatsapp_call(request)
      self.rpc(
        :DisconnectWhatsAppCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end

    # Connects a Twilio call to a LiveKit room.
    # @param request [Proto::ConnectTwilioCallRequest]
    # @return [Proto::ConnectTwilioCallResponse]
    def connect_twilio_call(request)
      self.rpc(
        :ConnectTwilioCall,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomCreate: true)),
      )
    end
  end
end
