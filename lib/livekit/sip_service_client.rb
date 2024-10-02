require "livekit/proto/livekit_sip_twirp"
require "livekit/auth_mixin"
require 'livekit/utils'

module LiveKit
  class SIPServiceClient < Twirp::Client
    client_for Proto::SIPService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(Utils.to_http_url(base_url), "/twirp"))
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
      # optional map SIP X-* headers from INVITE to SIP participant attributes.
      headers_to_attributes: nil
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
          headers_to_attributes: headers_to_attributes
        )
      )
      self.rpc(
        :CreateSIPInboundTrunk,
        request,
        headers: auth_header(nil, sip_grant: SIPGrant.new(admin: true)),
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
        headers: auth_header(nil, sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def list_sip_inbound_trunk
      request = Proto::ListSIPInboundTrunkRequest.new
      self.rpc(
        :ListSIPInboundTrunk,
        request,
        headers: auth_header(nil, sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def list_sip_outbound_trunk
      request = Proto::ListSIPOutboundTrunkRequest.new
      self.rpc(
        :ListSIPOutboundTrunk,
        request,
        headers: auth_header(nil, sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def delete_sip_trunk(sip_trunk_id)
      request = Proto::DeleteSIPTrunkRequest.new(
        sip_trunk_id: sip_trunk_id,
      )
      self.rpc(
        :DeleteSIPTrunk,
        request,
        headers: auth_header(nil, sip_grant: SIPGrant.new(admin: true)),
      )
    end

    def create_sip_dispatch_rule(
      rule,
      name: nil,
      trunk_ids: nil,
      inbound_numbers: nil,
      hide_phone_number: nil,
      metadata: nil,
      attributes: nil
    )
      request = Proto::CreateSIPDispatchRuleRequest.new(
        rule: rule,
        name: name,
        trunk_ids: trunk_ids,
        inbound_numbers: inbound_numbers,
        hide_phone_number: hide_phone_number,
        metadata: metadata,
        attributes: attributes,
      )
      self.rpc(
        :CreateSIPDispatchRule,
        request,
        headers: auth_header(nil, sip_grant: SIPGrant.new(admin: true)),
      )
    end
  end
end
