# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    # OmniAuth strategy for Health Planet
    class Tanita < OmniAuth::Strategies::OAuth2
      option :name, 'tanita'

      option :skip_info, true
      option :provider_ignores_state, true
      option :scope, 'innerscan'

      option :client_options, :site => 'https://www.healthplanet.jp',
               :authorize_url => '/oauth/auth'

    private

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
