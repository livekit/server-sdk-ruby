require 'spec_helper'

RSpec.describe LiveKit::ClaimGrant do
  describe 'initialization' do
    it 'initializes with nil attributes' do
      claim_grant = LiveKit::ClaimGrant.new
      expect(claim_grant.identity).to be_nil
      expect(claim_grant.name).to be_nil
      expect(claim_grant.metadata).to be_nil
      expect(claim_grant.sha256).to be_nil
      expect(claim_grant.video).to be_nil
    end
  end

  describe '.from_hash' do
    context 'when input is valid' do
      let(:input_hash) do
        {
          'sub' => '123',
          'name' => 'John Doe',
          'metadata' => 'User data',
          'sha256' => 'hashcode',
          'video' => {}
        }
      end

      it 'creates a ClaimGrant with proper attributes' do
        claim_grant = LiveKit::ClaimGrant.from_hash(input_hash)
        expect(claim_grant.identity).to eq('123')
        expect(claim_grant.name).to eq('John Doe')
        expect(claim_grant.metadata).to eq('User data')
        expect(claim_grant.sha256).to eq('hashcode')
        expect(claim_grant.video).to be_a(LiveKit::VideoGrant)
      end
    end

    context 'when input is nil' do
      it 'returns nil' do
        expect(LiveKit::ClaimGrant.from_hash(nil)).to be_nil
      end
    end

    context 'when input has symbol keys' do
      let(:input_hash_with_symbols) do
        {
          roomCreate: true,
          roomJoin: false,
          roomList: true,
          roomRecord: false,
          roomAdmin: true,
          "room": 'example_room',
          "canPublish": true,
          canPublishSources: ['video', 'audio'],
          canSubscribe: true,
          canPublishData: true,
          canUpdateOwnMetadata: false,
          hidden: false,
          recorder: true,
          ingressAdmin: true
        }
      end

      it 'creates a VideoGrant with proper attributes using symbol keys' do
        video_grant = LiveKit::VideoGrant.from_hash(input_hash_with_symbols)
        expect(video_grant.roomCreate).to eq(true)
        expect(video_grant.roomJoin).to eq(false)
        expect(video_grant.roomList).to eq(true)
        expect(video_grant.roomRecord).to eq(false)
        expect(video_grant.roomAdmin).to eq(true)
        expect(video_grant.room).to eq('example_room')
        expect(video_grant.canPublish).to eq(true)
        expect(video_grant.canPublishSources).to eq(['video', 'audio'])
        expect(video_grant.canSubscribe).to eq(true)
        expect(video_grant.canPublishData).to eq(true)
        expect(video_grant.canUpdateOwnMetadata).to eq(false)
        expect(video_grant.hidden).to eq(false)
        expect(video_grant.recorder).to eq(true)
        expect(video_grant.ingressAdmin).to eq(true)
      end
    end

  end

  describe '#to_hash' do
    it 'converts attributes to a hash correctly' do
      video_grant = LiveKit::VideoGrant.new
      claim_grant = LiveKit::ClaimGrant.new
      claim_grant.name = 'John Doe'
      claim_grant.metadata = 'User data'
      claim_grant.sha256 = 'hashcode'
      claim_grant.video = video_grant

      result = claim_grant.to_hash
      expect(result[:name]).to eq('John Doe')
      expect(result[:metadata]).to eq('User data')
      expect(result[:sha256]).to eq('hashcode')
      expect(result[:video]).to be_a(Hash)
    end
  end
end
