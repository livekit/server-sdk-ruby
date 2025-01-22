require "livekit/proto/livekit_agent_dispatch_twirp"
require "livekit/auth_mixin"
require 'livekit/utils'

module LiveKit
  # Client for LiveKit's Agent Dispatch Service, which manages agent assignments to rooms
  # This client handles creating, deleting, and retrieving agent dispatches
  class AgentDispatchServiceClient < Twirp::Client
    client_for Proto::SIPService
    include AuthMixin
    attr_accessor :api_key, :api_secret

    def initialize(base_url, api_key: nil, api_secret: nil)
      super(File.join(Utils.to_http_url(base_url), "/twirp"))
      @api_key = api_key
      @api_secret = api_secret
    end

    # Creates a new agent dispatch for a named agent
    # @param room_name [String] The room to dispatch the agent to
    # @param agent_name [String] The name of the agent to dispatch
    # @param metadata [String, nil] Optional metadata to include with the dispatch
    # @return [LiveKit::Proto::AgentDispatch] Dispatch that was just created
    def create_dispatch(
      # room to dispatch agent to
      room_name,
      # agent to dispatch
      agent_name,
      # optional, metadata to send along with the job
      metadata: nil
    )
      request = Proto::CreateAgentDispatchRequest.new(
        room: room_name,
        agent_name: agent_name,
        metadata: metadata,
      )
      self.rpc(
        :CreateDispatch,
        request,
        headers: auth_header(video_grant: VideoGrant.new(roomAdmin: true, room: room_name)),
      )
    end

    # Deletes an existing agent dispatch
    # @param dispatch_id [String] The ID of the dispatch to delete
    # @param room_name [String] The room name associated with the dispatch
    # @return [LiveKit::Proto::AgentDispatch] AgentDispatch record that was deleted
    def delete_dispatch(dispatch_id, room_name)
      request = Proto::DeleteAgentDispatchRequest.new(
        dispatch_id: dispatch_id,
        room: room_name,
      )
      self.rpc(
        :DeleteDispatch,
        request,
        headers: auth_header(VideoGrant.new(roomAdmin: true, room: room_name)),
      )
    end

    # Retrieves a specific agent dispatch by ID
    # @param dispatch_id [String] The ID of the dispatch to retrieve
    # @param room_name [String] The room name associated with the dispatch
    # @return [LiveKit::Proto::AgentDispatch, nil] The agent dispatch if found, nil otherwise
    def get_dispatch(dispatch_id, room_name)
      request = Proto::ListAgentDispatchRequest.new(
        dispatch_id: dispatch_id,
        room: room_name,
      )
      res = self.rpc(
        :ListDispatch,
        request,
        headers: auth_header(VideoGrant.new(roomAdmin: true, room: room_name)),
      )
      if res.agent_dispatches.size > 0
        return res.agent_dispatches[0]
      end
      nil
    end

    # Lists all agent dispatches for a specific room
    # @param room_name [String] The room name to list dispatches for
    # @return [Array<LiveKit::Proto::AgentDispatch>] Array of agent dispatches
    def list_dispatch(room_name)
      request = Proto::ListAgentDispatchRequest.new(
        room: room_name,
      )
      res = self.rpc(
        :ListDispatch,
        request,
        headers: auth_header(VideoGrant.new(roomAdmin: true, room: room_name)),
      )
      res.agent_dispatches
    end
  end
end
