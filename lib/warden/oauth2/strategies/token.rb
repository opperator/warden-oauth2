require 'warden-oauth2'

module Warden
  module OAuth2
    module Strategies
      class Token < Warden::Strategies::Base
        def authenticate!
          if token
            fail "Expired access token." and return if token.respond_to?(:expired?) && token.expired?
            fail "Insufficient scope." and return if token.respond_to?(:scope?) && !token.scope?(scope)
            success! token
          else
            fail "Invalid access token." and return unless token
          end
        end

        def token
          Warden::OAuth2.config.token_model.locate(token_string)
        end

        def token_string
          raise NotImplementedError
        end
      end
    end
  end
end
