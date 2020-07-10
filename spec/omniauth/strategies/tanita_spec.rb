# frozen_string_literal: true

require 'spec_helper'

describe OmniAuth::Strategies::Tanita do
  subject do
    described_class.new({})
  end

  context 'client options' do
    it 'has correct site' do
      expect(subject.client.site).to eq('https://www.healthplanet.jp')
    end

    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('/oauth/auth')
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq('/oauth/token')
    end

    it 'has default skip_info' do
      expect(subject.options[:skip_info]).to eq(true)
    end

    it 'has default provider_ignores_state' do
      expect(subject.options[:provider_ignores_state]).to eq(true)
    end

    it 'has default scope' do
      expect(subject.options[:scope]).to eq('innerscan')
    end
  end

  describe '#callback_url' do
    it 'returns callback url' do
      allow(subject).to receive(:full_host) { 'http://localhost' }
      allow(subject).to receive(:script_name) { '/v1' }
      expect(subject.send(:callback_url)).to eq 'http://localhost/v1/auth/tanita/callback'
    end
  end
end
