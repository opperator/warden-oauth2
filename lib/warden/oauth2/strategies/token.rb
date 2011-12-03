require 'warden-oauth2'

module Warden
  module OAuth2
    module Strategies
      class Token < Base
        def valid?
          !!token_string
        end

        def authenticate!
          if token
            fail! "invalid_token" and return if token.respond_to?(:expired?) && token.expired?
            fail! "insufficient_scope" and return if scope && token.respond_to?(:scope?) && !token.scope?(scope)
            success! token
          else
            fail! "invalid_request" and return unless token
          end
        end

        def token
          Warden::OAuth2.config.token_model.locate(token_string)
        end

        def token_string
          raise NotImplementedError
        end

        def error_status
          case message
            when "invalid_token" then 401
            when "insufficient_scope" then 403
            when "invalid_request" then 400
            else 400
          end
        end
      end
    end
  end
end
