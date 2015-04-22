require 'devise/strategies/token_authenticatable'

module Atmosphere
  module Api
    module ApplicationControllerExt
      extend ActiveSupport::Concern

      def delegate_auth
        nil
      end

      def token_request?
        token
      end

      private

      def token
        params[Devise::Strategies::TokenAuthenticatable.key].presence ||
          request.headers[Devise::Strategies::TokenAuthenticatable.header_key].
            presence
      end
    end
  end
end
