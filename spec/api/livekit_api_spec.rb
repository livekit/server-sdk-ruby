# frozen_string_literal: true

require 'json'
require 'faraday'
require 'livekit'

# API tests that drive the unified LiveKitAPI against the shared mock LiveKit
# server (livekit/livekit cmd/test-server). Point them at a running instance
# with LK_TEST_SERVER_URL (default http://127.0.0.1:9999); they skip when no
# server is reachable.
#
# Because the mock enforces the same per-method grants as the real server, a
# call that succeeds also proves the SDK attached the right grants. The smoke
# examples fully populate each request so they double as a reference for a
# complete call. Mock directives are injected as a default X-Lk-Mock header on a
# service's connection (the public methods don't expose per-call headers).
PB = LiveKit::Proto

RSpec.describe LiveKit::LiveKitAPI do
  base = ENV.fetch('LK_TEST_SERVER_URL', 'http://127.0.0.1:9999')
  server_up = begin
    Faraday.get("#{base}/settings/regions").status == 200
  rescue StandardError
    false
  end

  def new_api
    LiveKit::LiveKitAPI.new(
      ENV.fetch('LK_TEST_SERVER_URL', 'http://127.0.0.1:9999'),
      api_key: 'devkey', api_secret: 'secret'
    )
  end

  # Attach X-Lk-Mock directives to a service client's connection.
  def mock!(client, directives)
    client.instance_variable_get(:@conn).headers['X-Lk-Mock'] = JSON.generate(directives)
    client
  end

  unless server_up
    it 'is skipped because the mock test server is not reachable' do
      skip "mock test server not reachable at #{base}"
    end
    next
  end

  # -- smoke: fully-populated calls across every service ----------------------

  it 'room service smoke' do
    api = new_api
    expect do
      api.room.create_room('test-room', empty_timeout: 300, departure_timeout: 60,
                            max_participants: 50, metadata: '{"scene":"lobby"}',
                            min_playout_delay: 100, max_playout_delay: 2000, sync_streams: true)
      api.room.list_rooms(names: ['test-room', 'lobby'])
      api.room.delete_room(room: 'test-room')
      api.room.list_participants(room: 'test-room')
      api.room.get_participant(room: 'test-room', identity: 'participant-42')
      api.room.remove_participant(room: 'test-room', identity: 'participant-42')
      api.room.forward_participant(room: 'test-room', identity: 'participant-42',
                                   destination_room: 'overflow-room')
      api.room.move_participant(room: 'test-room', identity: 'participant-42',
                                destination_room: 'breakout-room')
      api.room.mute_published_track(room: 'test-room', identity: 'participant-42',
                                    track_sid: 'TR_video1', muted: true)
      api.room.update_participant(room: 'test-room', identity: 'participant-42', name: 'Alice',
                                  metadata: '{"role":"host"}', attributes: { 'seat' => '1A' },
                                  permission: PB::ParticipantPermission.new(
                                    can_subscribe: true, can_publish: true, can_publish_data: true,
                                    can_publish_sources: [PB::TrackSource::MICROPHONE, PB::TrackSource::CAMERA],
                                    can_update_metadata: true
                                  ))
      api.room.update_subscriptions(room: 'test-room', identity: 'participant-42',
                                    track_sids: ['TR_video1'], subscribe: true)
      api.room.update_room_metadata(room: 'test-room', metadata: '{"scene":"intro"}')
      api.room.send_data(room: 'test-room', data: 'hello world', kind: PB::DataPacket::Kind::RELIABLE,
                         destination_identities: ['participant-42'])
    end.not_to raise_error
  end

  it 'egress service smoke' do
    api = new_api
    mp4 = -> { PB::EncodedFileOutput.new(file_type: PB::EncodedFileType::MP4, filepath: 'out.mp4') }
    stream = PB::StreamOutput.new(protocol: PB::StreamProtocol::RTMP, urls: ['rtmps://a.example.com/live/key'])
    expect do
      api.egress.start_room_composite_egress('test-room', mp4.call, layout: 'grid')
      api.egress.start_web_egress('https://example.com/scene', stream)
      api.egress.start_participant_egress('test-room', 'participant-42', mp4.call, screen_share: true)
      api.egress.start_track_composite_egress('test-room', mp4.call,
                                              audio_track_id: 'TR_audio1', video_track_id: 'TR_video1')
      api.egress.start_track_egress('test-room', PB::DirectFileOutput.new(filepath: 'track.mp4'), 'TR_video1')
      api.egress.update_layout('EG_abc123', 'speaker')
      api.egress.update_stream('EG_abc123', add_output_urls: ['rtmps://b.example.com/live/key'],
                                            remove_output_urls: ['rtmps://a.example.com/live/key'])
      api.egress.list_egress(room_name: 'test-room', egress_id: 'EG_abc123', active: true)
      api.egress.stop_egress('EG_abc123')
    end.not_to raise_error
  end

  it 'ingress service smoke' do
    api = new_api
    expect do
      api.ingress.create_ingress(
        PB::IngressInput::RTMP_INPUT, name: 'stream-input', room_name: 'test-room',
        participant_identity: 'ingress-bot', participant_name: 'Live Stream', enable_transcoding: true,
        audio: PB::IngressAudioOptions.new(name: 'audio', source: PB::TrackSource::MICROPHONE,
                                           preset: PB::IngressAudioEncodingPreset::OPUS_STEREO_96KBPS),
        video: PB::IngressVideoOptions.new(name: 'video', source: PB::TrackSource::CAMERA,
                                           preset: PB::IngressVideoEncodingPreset::H264_1080P_30FPS_3_LAYERS)
      )
      api.ingress.update_ingress('IN_abc123', name: 'stream-input-v2', room_name: 'test-room',
                                 participant_identity: 'ingress-bot', enable_transcoding: true)
      api.ingress.list_ingress(room_name: 'test-room', ingress_id: 'IN_abc123')
      api.ingress.delete_ingress('IN_abc123')
    end.not_to raise_error
  end

  it 'sip service smoke' do
    api = new_api
    expect do
      api.sip.create_sip_inbound_trunk('inbound', ['+15105550100'], metadata: '{"provider":"telco"}',
                                       allowed_addresses: ['203.0.113.0/24'], allowed_numbers: ['+15105550111'],
                                       auth_username: 'sip-user', auth_password: 'sip-pass', krisp_enabled: true)
      api.sip.create_sip_outbound_trunk('outbound', 'sip.telco.example.com', ['+15105550100'],
                                        transport: PB::SIPTransport::SIP_TRANSPORT_TLS,
                                        auth_username: 'sip-user', auth_password: 'sip-pass')
      api.sip.update_sip_inbound_trunk('ST_abc123',
                                       PB::SIPInboundTrunkInfo.new(name: 'inbound-v2', numbers: ['+15105550100']))
      api.sip.update_sip_outbound_trunk('ST_abc123',
                                        PB::SIPOutboundTrunkInfo.new(name: 'outbound-v2', address: 'sip.telco.example.com',
                                                                     transport: PB::SIPTransport::SIP_TRANSPORT_TLS,
                                                                     numbers: ['+15105550100']))
      api.sip.list_sip_inbound_trunk
      api.sip.list_sip_outbound_trunk
      api.sip.delete_sip_trunk('ST_abc123')
      api.sip.create_sip_dispatch_rule(
        PB::SIPDispatchRule.new(dispatch_rule_direct: PB::SIPDispatchRuleDirect.new(room_name: 'support', pin: '1234')),
        name: 'direct-to-support', trunk_ids: ['ST_abc123'], metadata: '{"team":"support"}'
      )
      api.sip.update_sip_dispatch_rule('SDR_abc123',
                                       PB::SIPDispatchRuleInfo.new(name: 'individual-v2',
                                                                   rule: PB::SIPDispatchRule.new(
                                                                     dispatch_rule_individual: PB::SIPDispatchRuleIndividual.new(room_prefix: 'call-')
                                                                   )))
      api.sip.list_sip_dispatch_rule
      api.sip.delete_sip_dispatch_rule('SDR_abc123')
    end.not_to raise_error
  end

  it 'connector service smoke' do
    api = new_api
    offer = PB::SessionDescription.new(type: 'offer', sdp: "v=0\r\no=- 0 0 IN IP4 127.0.0.1\r\n")
    answer = PB::SessionDescription.new(type: 'answer', sdp: "v=0\r\no=- 0 0 IN IP4 127.0.0.1\r\n")
    expect do
      api.connector.dial_whatsapp_call(PB::DialWhatsAppCallRequest.new(
                                         whatsapp_phone_number_id: '123456789012345', whatsapp_to_phone_number: '+15105550100',
                                         whatsapp_api_key: 'wa-secret-key', whatsapp_cloud_api_version: '23.0',
                                         room_name: 'test-room', participant_identity: 'whatsapp-caller', destination_country: 'US'
                                       ))
      api.connector.accept_whatsapp_call(PB::AcceptWhatsAppCallRequest.new(
                                           whatsapp_phone_number_id: '123456789012345', whatsapp_api_key: 'wa-secret-key',
                                           whatsapp_cloud_api_version: '23.0', whatsapp_call_id: 'wacid.HBgLABC', sdp: answer,
                                           room_name: 'test-room', participant_identity: 'whatsapp-callee'
                                         ))
      api.connector.connect_whatsapp_call(PB::ConnectWhatsAppCallRequest.new(whatsapp_call_id: 'wacid.HBgLABC', sdp: offer))
      api.connector.disconnect_whatsapp_call(PB::DisconnectWhatsAppCallRequest.new(
                                               whatsapp_call_id: 'wacid.HBgLABC', whatsapp_api_key: 'wa-secret-key',
                                               disconnect_reason: PB::DisconnectWhatsAppCallRequest::DisconnectReason::BUSINESS_INITIATED
                                             ))
      api.connector.connect_twilio_call(PB::ConnectTwilioCallRequest.new(
                                          twilio_call_direction: PB::ConnectTwilioCallRequest::TwilioCallDirection::TWILIO_CALL_DIRECTION_INBOUND,
                                          room_name: 'test-room', participant_identity: 'twilio-caller', destination_country: 'US'
                                        ))
    end.not_to raise_error
  end

  it 'agent dispatch service smoke' do
    api = new_api
    expect do
      api.agent_dispatch.create_dispatch('test-room', 'inbound-agent', metadata: '{"lang":"en"}')
      api.agent_dispatch.get_dispatch('AD_abc123', 'test-room')
      api.agent_dispatch.list_dispatch('test-room')
      api.agent_dispatch.delete_dispatch('AD_abc123', 'test-room')
    end.not_to raise_error
  end

  # -- deep: create_room round-trip + error propagation -----------------------

  it 'create_room echoes request fields' do
    room = new_api.room.create_room('echo-room', metadata: '{"scene":"lobby"}',
                                    empty_timeout: 300, max_participants: 50)
    expect(room.name).to eq('echo-room')
    expect(room.metadata).to eq('{"scene":"lobby"}')
    expect(room.empty_timeout).to eq(300)
    expect(room.max_participants).to eq(50)
    expect(room.sid).not_to be_empty # placeholder assigned by the mock
  end

  it 'raises ServerError on a server error' do
    api = new_api
    mock!(api.room, { 'failRegions' => [0], 'failStatus' => 400, 'failTwirpCode' => 'invalid_argument' })
    expect { api.room.create_room('test-room') }.to raise_error(LiveKit::ServerError) do |e|
      expect(e.code).to eq('invalid_argument')
    end
  end

  # -- deep: SIP participant (delayMs:0 skips the mock's answer wait) ----------

  it 'creates and transfers SIP participants' do
    api = new_api
    p = api.sip.create_sip_participant('ST_abc123', '+15105550100', 'test-room',
                                       participant_identity: 'sip-caller', participant_name: 'SIP Caller',
                                       participant_metadata: '{"source":"pstn"}', dtmf: '1234#',
                                       play_dialtone: true, max_call_duration: 3600)
    expect(p.room_name).to eq('test-room')
    expect(p.participant_identity).to eq('sip-caller')

    # Inline outbound trunk config (no stored trunk id) + custom caller ID.
    inline = api.sip.create_sip_participant('', '+15105550100', 'test-room',
                                            trunk: LiveKit::Proto::SIPOutboundConfig.new(
                                              hostname: 'sip.telco.example.com',
                                              transport: :SIP_TRANSPORT_UDP
                                            ),
                                            from_number: '+15105550199', display_name: 'Support',
                                            participant_identity: 'sip-inline')
    expect(inline.room_name).to eq('test-room')

    mock!(api.sip, { 'delayMs' => 0 })
    expect do
      api.sip.create_sip_participant('ST_abc123', '+15105550100', 'test-room',
                                     wait_until_answered: true, ringing_timeout: 2)
      api.sip.transfer_sip_participant('test-room', 'sip-caller', 'tel:+15105550122', ringing_timeout: 2)
    end.not_to raise_error
  end

  # -- cross-cutting: token auth ----------------------------------------------

  it 'authenticates with a pre-signed token' do
    token = LiveKit::AccessToken.new(api_key: 'devkey', api_secret: 'secret')
    token.video_grant = LiveKit::VideoGrant.new(roomCreate: true)
    api = LiveKit::LiveKitAPI.new(base, token: token.to_jwt)
    room = api.room.create_room('token-room')
    expect(room.name).to eq('token-room')
  end

  # -- cross-cutting: SIP call errors raise SipCallError ----------------------

  def sip_error(sip, wait: false)
    api = new_api
    mock!(api.sip, { 'delayMs' => 0, 'sipStatus' => sip })
    begin
      api.sip.create_sip_participant('ST_abc123', '+15105550100', 'test-room', wait_until_answered: wait,
                                     ringing_timeout: (wait ? 2 : nil))
      nil
    rescue LiveKit::SipCallError => e
      e
    end
  end

  it 'surfaces a busy signal as SipCallError' do
    e = sip_error({ 'code' => 486, 'status' => 'Busy Here' })
    expect(e).to be_a(LiveKit::ServerError)
    expect(e.code).to eq('resource_exhausted')
    expect(e.sip_status_code).to eq(486)
    expect(e.sip_status).to eq('Busy Here')
    expect(e.to_s).to include('486').and include('Busy Here')
  end

  it 'surfaces a carrier decline as SipCallError' do
    e = sip_error({ 'code' => 603, 'status' => 'Decline' })
    expect(e.code).to eq('permission_denied')
    expect(e.sip_status_code).to eq(603)
  end

  it 'surfaces a no-answer timeout (SIP 408)' do
    e = sip_error({ 'code' => 408, 'status' => 'Request Timeout' }, wait: true)
    expect(e.code).to eq('deadline_exceeded')
    expect(e.sip_status_code).to eq(408)
  end

  # -- cross-cutting: client-side dial timeout --------------------------------

  it 'times out when the answer exceeds the dial budget' do
    api = new_api
    mock!(api.sip, { 'delayMs' => 4000 }) # exceeds the ~3s dial budget (ringing 1s + margin)
    expect do
      api.sip.create_sip_participant('ST_abc123', '+15105550100', 'test-room',
                                     wait_until_answered: true, ringing_timeout: 1)
    end.to raise_error(Faraday::TimeoutError)
  end
end
