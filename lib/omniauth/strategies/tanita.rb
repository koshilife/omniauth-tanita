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
      option :scope, TANITA::Scope::INNERSCAN

      option :client_options, :site => TANITA::BASE_URL,
               :authorize_url => TANITA::AUTH_URL_PATH,
               :token_url => TANITA::TOKEN_URL_PATH

      def callback_url
        full_host + script_name + callback_path
     end

    end
  end
end
