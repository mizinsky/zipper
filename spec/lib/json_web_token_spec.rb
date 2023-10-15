# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JsonWebToken, type: :lib do
  let(:user) { create(:user) }
  let(:payload) { { user_id: user.id } }
  let(:token) { described_class.encode(payload) }

  describe '.encode' do
    it 'encodes the payload' do
      expect(token).to be_present
    end

    it 'includes user_id in the encoded token' do
      expect(described_class.decode(token).with_indifferent_access).to include(payload)
    end

    it 'includes exp in the encoded token' do
      decoded_token = described_class.decode(token)
      expect(decoded_token['exp']).to be_present
    end
  end

  describe '.decode' do
    it 'decodes the token' do
      expect(described_class.decode(token)).to be_a(Hash)
    end

    it 'returns payload content' do
      expect(described_class.decode(token)['user_id']).to eq(payload[:user_id])
    end

    context 'when token is expired' do
      let!(:token) { described_class.encode(payload) }

      it 'raises JWT::ExpiredSignature error' do
        travel_to 20.minutes.from_now do
          expect { described_class.decode(token) }.to raise_error(JWT::ExpiredSignature)
        end
      end
    end
  end
end
