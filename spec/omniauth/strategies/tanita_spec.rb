# frozen_string_literal: true

require 'spec_helper'
require 'json'
require 'stringio'

describe OmniAuth::Strategies::Tanita do
  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}) }

  let(:app) do
    lambda do
      [200, {}, ['Hello.']]
    end
  end

  subject do
    args = [app, 'appid', 'secret', @options || {}].compact
    OmniAuth::Strategies::Tanita.new(*args).tap do |strategy|
      allow(strategy).to receive(:request) do
        request
      end
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client_options' do
    it 'has correct site' do
      expect(subject.client.site).to eq(Tanita::Api::Client::BASE_URL)
    end

    it 'has correct authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq(Tanita::Api::Client::AUTH_URL_PATH)
    end

    it 'has correct token_url' do
      expect(subject.client.options[:token_url]).to eq(Tanita::Api::Client::TOKEN_URL_PATH)
    end

    describe 'overrides' do
      context 'as strings' do
        it 'should allow overriding the site' do
          @options = {:client_options => {'site' => 'https://example.com'}}
          expect(subject.client.site).to eq('https://example.com')
        end

        it 'should allow overriding the authorize_url' do
          @options = {:client_options => {'authorize_url' => 'https://example.com'}}
          expect(subject.client.options[:authorize_url]).to eq('https://example.com')
        end

        it 'should allow overriding the token_url' do
          @options = {:client_options => {'token_url' => 'https://example.com'}}
          expect(subject.client.options[:token_url]).to eq('https://example.com')
        end
      end
    end
  end

  describe '#authorize_options' do
    describe 'client_id' do
      it 'should support client_id' do
        @options = {}
        expect(subject.authorize_params['client_id']).to eq('appid')
      end
    end

    %i[redirect_uri scope response_type].each do |k|
      it "should support #{k}" do
        @options = {k => 'http://someval'}
        expect(subject.authorize_params[k.to_s]).to eq('http://someval')
      end
    end

    describe 'redirect_uri' do
      it 'should default to nil' do
        @options = {}
        expect(subject.authorize_params['redirect_uri']).to eq(nil)
      end

      it 'should set the redirect_uri parameter if present' do
        @options = {:redirect_uri => 'https://example.com'}
        expect(subject.authorize_params['redirect_uri']).to eq('https://example.com')
      end
    end

    describe 'scope' do
      it 'scope' do
        @options = {}
        expect(subject.authorize_params['scope']).to eq(Tanita::Api::Client::Scope::INNERSCAN)
      end

      it 'should set the scope parameter if present' do
        @options = {:scope => 'scope_a,scope_b'}
        expect(subject.authorize_params['scope']).to eq('scope_a,scope_b')
      end
    end

    describe 'response_type' do
      it 'response_type' do
        @options = {}
        expect(subject.authorize_params['response_type']).to eq('code')
      end

      it 'should set the response_type parameter if present' do
        @options = {:response_type => 'hoge'}
        expect(subject.authorize_params['response_type']).to eq('hoge')
      end
    end

    describe 'overrides' do
      it 'should include top-level options that are marked as :authorize_options' do
        @options = {:authorize_options => %i[scope foo response_type], :scope => 'http://bar', :foo => 'baz', :response_type => 'something'}
        expect(subject.authorize_params['scope']).to eq('http://bar')
        expect(subject.authorize_params['foo']).to eq('baz')
        expect(subject.authorize_params['response_type']).to eq('something')
      end
    end
  end

  describe '#authorize_params' do
    it 'should include any authorize params passed in the :authorize_params option' do
      @options = {:authorize_params => {:foo => 'bar', :baz => 'zip'}, :bad => 'not_included'}
      expect(subject.authorize_params['foo']).to eq('bar')
      expect(subject.authorize_params['baz']).to eq('zip')
      expect(subject.authorize_params['bad']).to eq(nil)
    end
  end

  describe '#token_options' do
    describe 'client_id' do
      it 'should support client_id' do
        expect(subject.token_params['client_id']).to eq('appid')
      end
    end

    describe 'client_secret' do
      it 'should support client_secret' do
        expect(subject.token_params['client_secret']).to eq('secret')
      end
    end

    describe 'redirect_uri' do
      it 'should default to nil' do
        @options = {}
        expect(subject.token_params['redirect_uri']).to eq(nil)
      end

      it 'should set the redirect_uri parameter if present' do
        @options = {:redirect_uri => 'https://example.com'}
        expect(subject.token_params['redirect_uri']).to eq('https://example.com')
      end
    end

    describe 'grant_type' do
      it 'should default to "authorization_code"' do
        @options = {}
        expect(subject.token_params['grant_type']).to eq('authorization_code')
      end

      it 'should set the redirect_uri parameter if present' do
        @options = {:grant_type => 'something'}
        expect(subject.token_params['grant_type']).to eq('something')
      end
    end

    it 'should include top-level options that are marked as :token_options' do
      @options = {:token_options => %i[scope foo], :scope => 'bar', :foo => 'baz', :bad => 'not_included'}
      expect(subject.token_params['client_id']).to eq(nil)
      expect(subject.token_params['client_secret']).to eq(nil)
      expect(subject.token_params['redirect_uri']).to eq(nil)
      expect(subject.token_params['grant_type']).to eq(nil)
      expect(subject.token_params['scope']).to eq('bar')
      expect(subject.token_params['foo']).to eq('baz')
      expect(subject.token_params['bad']).to eq(nil)
    end
  end

  describe '#token_params' do
    it 'should include any token params passed in the :token_params option' do
      @options = {:token_params => {:foo => 'bar', :baz => 'zip', :redirect_uri => 'https://example.com', :grant_type => 'something'}}
      expect(subject.token_params['client_id']).to eq('appid')
      expect(subject.token_params['client_secret']).to eq('secret')
      expect(subject.token_params['redirect_uri']).to eq('https://example.com')
      expect(subject.token_params['grant_type']).to eq('authorization_code')
      expect(subject.token_params['foo']).to eq('bar')
      expect(subject.token_params['baz']).to eq('zip')
    end
  end
end
