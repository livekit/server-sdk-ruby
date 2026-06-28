# frozen_string_literal: true

require 'spec_helper'

RSpec.describe LiveKit::AgentDispatchServiceClient do
  let(:base_url) { 'http://localhost:7880' }
  let(:api_key) { 'test_api_key' }
  let(:api_secret) { 'test_api_secret' }
  let(:client) { described_class.new(base_url, api_key: api_key, api_secret: api_secret) }
  let(:room_name) { 'test-room' }
  let(:agent_name) { 'test-agent' }
  let(:dispatch_id) { 'dispatch-123' }

  describe '#create_dispatch' do
    it 'calls auth_header with keyword arguments' do
      expect(client).to receive(:auth_header).with(
        video_grant: have_attributes(roomAdmin: true, room: room_name)
      ).and_call_original

      # Mock the RPC call to avoid actual network request
      allow(client).to receive(:rpc).and_return(
        LiveKit::Proto::AgentDispatch.new(id: dispatch_id)
      )

      client.create_dispatch(room_name, agent_name)
    end
  end

  describe '#delete_dispatch' do
    it 'calls auth_header with keyword arguments' do
      expect(client).to receive(:auth_header).with(
        video_grant: instance_of(LiveKit::VideoGrant)
      ).and_call_original

      # Mock the RPC call to avoid actual network request
      allow(client).to receive(:rpc).and_return(
        LiveKit::Proto::AgentDispatch.new(id: dispatch_id)
      )

      client.delete_dispatch(dispatch_id, room_name)
    end
  end

  describe '#get_dispatch' do
    it 'calls auth_header with keyword arguments' do
      expect(client).to receive(:auth_header).with(
        video_grant: instance_of(LiveKit::VideoGrant)
      ).and_call_original

      # Mock the RPC call to avoid actual network request
      allow(client).to receive(:rpc).and_return(
        LiveKit::Proto::ListAgentDispatchResponse.new(
          agent_dispatches: [LiveKit::Proto::AgentDispatch.new(id: dispatch_id)]
        )
      )

      client.get_dispatch(dispatch_id, room_name)
    end
  end

  describe '#list_dispatch' do
    it 'calls auth_header with keyword arguments' do
      expect(client).to receive(:auth_header).with(
        video_grant: instance_of(LiveKit::VideoGrant)
      ).and_call_original

      # Mock the RPC call to avoid actual network request
      allow(client).to receive(:rpc).and_return(
        LiveKit::Proto::ListAgentDispatchResponse.new(
          agent_dispatches: []
        )
      )

      client.list_dispatch(room_name)
    end
  end

  describe 'Ruby 3 compatibility' do
    it 'does not raise ArgumentError when calling methods' do
      # Mock the RPC calls
      allow(client).to receive(:rpc).and_return(
        LiveKit::Proto::AgentDispatch.new(id: dispatch_id)
      )

      expect { client.create_dispatch(room_name, agent_name) }.not_to raise_error
      expect { client.delete_dispatch(dispatch_id, room_name) }.not_to raise_error

      allow(client).to receive(:rpc).and_return(
        LiveKit::Proto::ListAgentDispatchResponse.new(agent_dispatches: [])
      )

      expect { client.get_dispatch(dispatch_id, room_name) }.not_to raise_error
      expect { client.list_dispatch(room_name) }.not_to raise_error
    end
  end
end
