# frozen_string_literal: true

require 'omniauth-oauth2'
require 'tanita/api/client'

module OmniAuth
  module Strategies
    TANITA = Tanita::Api::Client

    class Tanita < OmniAuth::Strategies::OAuth2
      option :name, 'tanita'

      option :skip_info, true
      option :provider_ignores_state, true

      option :client_options, :site => TANITA::BASE_URL,
               :authorize_url => TANITA::AUTH_URL_PATH,
               :token_url => TANITA::TOKEN_URL_PATH

      option :authorize_options, %i[client_id redirect_uri scope response_type]
      option :response_type, 'code'
      option :scope, TANITA::Scope::INNERSCAN

      option :token_options, %i[client_id client_secret redirect_uri grant_type]
      option :grant_type, 'authorization_code'
    end
  end
end
