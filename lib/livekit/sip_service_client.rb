require "livekit/proto/livekit_sip_twirp"
require "livekit/auth_mixin"
require 'livekit/utils'
require 'livekit/failover'
require 'livekit/dial_timeout'

module LiveKit
  class SIPServiceClient < Twirp::Client
    client_for Proto::SIPService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil, failover: true)
      super(LiveKit::Failover.connection(base_url, failover))
      @api_key = api_key
      @api_secret = api_secret
    end

    def create_sip_inbound_trunk(
      # name to identify the trunk
      name,
      # numbers associated with LiveKit SIP. The Trunk will only accept calls made to these numbers.
      numbers,
      # optional, metadata to attach to the trunk
      metadata: nil,
      # optional, CIDR or IPs that traffic is accepted from.
      allowed_addresses: nil,
      # CIDR or IPs that traffic is accepted from.
      allowed_numbers: nil,
      # optional, Username and password used to authenticate inbound SIP invites.
      auth_username: nil,
      auth_password: nil,
      # optional, include these SIP X-* headers in 200 OK responses.
      headers: nil,
      # optional, map SIP X-* headers from INVITE to SIP participant attributes.
      headers_to_attributes: nil,
      # optional, map SIP response headers from INVITE to sip.h.* participant attributes automatically.
      include_headers: Proto::SIPHeaderOptions::SIP_NO_HEADERS,
      # optional, enable Krisp for this trunk
      krisp_enabled: false
    )
      request = Proto::CreateSIPInboundTrunkRequest.new(
        trunk: Proto::SIPInboundTrunkInfo.new(
          name: name,
          metadata: metadata,
          numbers: numbers,
          allowed_addresses: allowed_addresses,
          allowed_numbers: allowed_numbers,
          auth_username: auth_username,
          auth_password: auth_password,
          headers: headers,
          headers_to_attributes: headers_to_attributes,
          include_headers: include_headers,
          krisp_enabled: krisp_enabled
        )
      )
      self.rpc(
        :CreateSIPInboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def create_sip_outbound_trunk(
      # name to identify the trunk
      name,
      # Hostname or IP that SIP INVITE is sent too.
      address,
      # Numbers used to make the calls. Random one from this list will be selected.
      numbers,
      # optional, metadata to attach to the trunk
      metadata: nil,
      # SIP Transport used for outbound call.
      transport: nil,
      # optional, Username and password used to authenticate inbound SIP invites.
      auth_username: nil,
      auth_password: nil,
      # optional, include these SIP X-* headers in 200 OK responses.
      headers: nil,
      # optional map SIP X-* headers from INVITE to SIP participant attributes.
      headers_to_attributes: nil
    )
      request = Proto::CreateSIPOutboundTrunkRequest.new(
        trunk: Proto::SIPOutboundTrunkInfo.new(
          name: name,
          address: address,
          numbers: numbers,
          metadata: metadata,
          transport: transport,
          auth_username: auth_username,
          auth_password: auth_password,
          headers: headers,
          headers_to_attributes: headers_to_attributes
        )
      )
      self.rpc(
        :CreateSIPOutboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def list_sip_inbound_trunk
      request = Proto::ListSIPInboundTrunkRequest.new
      self.rpc(
        :ListSIPInboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def list_sip_outbound_trunk
      request = Proto::ListSIPOutboundTrunkRequest.new
      self.rpc(
        :ListSIPOutboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def delete_sip_trunk(sip_trunk_id)
      request = Proto::DeleteSIPTrunkRequest.new(
        sip_trunk_id: sip_trunk_id,
      )
      self.rpc(
        :DeleteSIPTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def create_sip_dispatch_rule(
      rule,
      name: nil,
      trunk_ids: nil,
      inbound_numbers: nil,
      hide_phone_number: nil,
      metadata: nil,
      attributes: nil,
      room_config: nil
    )
      request = Proto::CreateSIPDispatchRuleRequest.new(
        rule: rule,
        name: name,
        trunk_ids: trunk_ids,
        inbound_numbers: inbound_numbers,
        hide_phone_number: hide_phone_number,
        metadata: metadata,
        attributes: attributes,
        room_config: room_config,
      )
      self.rpc(
        :CreateSIPDispatchRule,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def list_sip_dispatch_rule
      request = Proto::ListSIPDispatchRuleRequest.new
      self.rpc(
        :ListSIPDispatchRule,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def delete_sip_dispatch_rule(sip_dispatch_rule_id)
      request = Proto::DeleteSIPDispatchRuleRequest.new(
        sip_dispatch_rule_id: sip_dispatch_rule_id,
      )
      self.rpc(
        :DeleteSIPDispatchRule,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def create_sip_participant(
      sip_trunk_id,
      sip_call_to,
      room_name,
      # Optional SIP From number to use. If empty, trunk number is used.
      from_number: nil,
      # Optional identity of the participant in LiveKit room
      participant_identity: nil,
      # Optional name of the participant in LiveKit room
      participant_name: nil,
      # Optional metadata of the participant in LiveKit room
      participant_metadata: nil,
      # Optional, send following DTMF digits (extension codes) when making a call.
      # Character 'w' can be used to add a 0.5 sec delay.
      dtmf: nil,
      # Optional, play dialtone for the participant
      play_dialtone: false,
      # Optional, hide phone number from participant attributes
      hide_phone_number: nil,
      # Optional, ringing timeout in seconds
      ringing_timeout: nil,
      # Optional, max call duration in seconds
      max_call_duration: nil,
      # Optional, enable Krisp for this call
      krisp_enabled: false,
      # Optional, wait for the call to be answered before returning
      wait_until_answered: false,
      # Optional, request timeout in seconds. Defaults to a longer value when
      # wait_until_answered is set (dialing takes time).
      timeout: nil
    )
      # When waiting for an answer, pin the ring window explicitly so our request
      # timeout doesn't depend on the server's default (which could change).
      ringing_timeout = DialTimeout::DEFAULT_RINGING_TIMEOUT if wait_until_answered && ringing_timeout.nil?
      request = Proto::CreateSIPParticipantRequest.new(
        sip_trunk_id: sip_trunk_id,
        sip_call_to: sip_call_to,
        sip_number: from_number,
        room_name: room_name,
        participant_identity: participant_identity,
        participant_name: participant_name,
        participant_metadata: participant_metadata,
        dtmf: dtmf,
        play_dialtone: play_dialtone,
        hide_phone_number: hide_phone_number,
        ringing_timeout: ringing_timeout,
        max_call_duration: max_call_duration,
        krisp_enabled: krisp_enabled,
        wait_until_answered: wait_until_answered
      )
      headers = auth_header(sip_grant: SIPGrant.new(call: true))
      # When waiting for an answer, dialing takes longer than a normal request
      # and the request must outlast ringing; otherwise honor any user timeout.
      effective_timeout = wait_until_answered ? DialTimeout.resolve(timeout, ringing_timeout) : timeout
      headers[Failover::TIMEOUT_HEADER] = effective_timeout.to_s if effective_timeout
      self.rpc(:CreateSIPParticipant, request, headers: headers)
    end

    def transfer_sip_participant(
      room_name,
      participant_identity,
      transfer_to,
      play_dialtone: nil,
      # Optional, max time for the transfer destination to answer, in seconds.
      ringing_timeout: nil,
      # Optional, request timeout in seconds. Defaults to a longer value since
      # transferring dials a phone.
      timeout: nil
    )

      # Transferring a call dials a phone and must outlast ringing. Pin the ring
      # window explicitly so our request timeout doesn't depend on the server default.
      ringing_timeout ||= DialTimeout::DEFAULT_RINGING_TIMEOUT
      request = Proto::TransferSIPParticipantRequest.new(
        room_name: room_name,
        participant_identity: participant_identity,
        transfer_to: transfer_to,
        play_dialtone: play_dialtone,
        ringing_timeout: ringing_timeout,
      )
      headers = auth_header(video_grant: VideoGrant.new(roomAdmin: true, room: room_name), sip_grant: SIPGrant.new(call: true))
      headers[Failover::TIMEOUT_HEADER] = DialTimeout.resolve(timeout, ringing_timeout).to_s
      self.rpc(:TransferSIPParticipant, request, headers: headers)
    end

    # Updates an existing SIP inbound trunk, replacing it entirely.
    #
    # @param sip_trunk_id [String] ID of the SIP inbound trunk to update
    # @param trunk [Proto::SIPInboundTrunkInfo] the full trunk definition to replace it with
    def update_sip_inbound_trunk(sip_trunk_id, trunk)
      request = Proto::UpdateSIPInboundTrunkRequest.new(
        sip_trunk_id: sip_trunk_id,
        replace: trunk,
      )
      self.rpc(
        :UpdateSIPInboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    # Updates specific fields of an existing SIP inbound trunk. Only the fields
    # set in +update+ are changed.
    #
    # @param sip_trunk_id [String] ID of the SIP inbound trunk to update
    # @param update [Proto::SIPInboundTrunkUpdate] the fields to update
    def update_sip_inbound_trunk_fields(sip_trunk_id, update)
      request = Proto::UpdateSIPInboundTrunkRequest.new(
        sip_trunk_id: sip_trunk_id,
        update: update,
      )
      self.rpc(
        :UpdateSIPInboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    # Updates an existing SIP outbound trunk, replacing it entirely.
    #
    # @param sip_trunk_id [String] ID of the SIP outbound trunk to update
    # @param trunk [Proto::SIPOutboundTrunkInfo] the full trunk definition to replace it with
    def update_sip_outbound_trunk(sip_trunk_id, trunk)
      request = Proto::UpdateSIPOutboundTrunkRequest.new(
        sip_trunk_id: sip_trunk_id,
        replace: trunk,
      )
      self.rpc(
        :UpdateSIPOutboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    # Updates specific fields of an existing SIP outbound trunk. Only the fields
    # set in +update+ are changed.
    #
    # @param sip_trunk_id [String] ID of the SIP outbound trunk to update
    # @param update [Proto::SIPOutboundTrunkUpdate] the fields to update
    def update_sip_outbound_trunk_fields(sip_trunk_id, update)
      request = Proto::UpdateSIPOutboundTrunkRequest.new(
        sip_trunk_id: sip_trunk_id,
        update: update,
      )
      self.rpc(
        :UpdateSIPOutboundTrunk,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    # Updates an existing SIP dispatch rule, replacing it entirely.
    #
    # @param sip_dispatch_rule_id [String] ID of the SIP dispatch rule to update
    # @param rule [Proto::SIPDispatchRuleInfo] the full dispatch rule definition to replace it with
    def update_sip_dispatch_rule(sip_dispatch_rule_id, rule)
      request = Proto::UpdateSIPDispatchRuleRequest.new(
        sip_dispatch_rule_id: sip_dispatch_rule_id,
        replace: rule,
      )
      self.rpc(
        :UpdateSIPDispatchRule,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end

    # Updates specific fields of an existing SIP dispatch rule. Only the fields
    # set in +update+ are changed.
    #
    # @param sip_dispatch_rule_id [String] ID of the SIP dispatch rule to update
    # @param update [Proto::SIPDispatchRuleUpdate] the fields to update
    def update_sip_dispatch_rule_fields(sip_dispatch_rule_id, update)
      request = Proto::UpdateSIPDispatchRuleRequest.new(
        sip_dispatch_rule_id: sip_dispatch_rule_id,
        update: update,
      )
      self.rpc(
        :UpdateSIPDispatchRule,
        request,
        headers: auth_header(sip_grant: SIPGrant.new(admin: true)),
      )
    end
  end
end
