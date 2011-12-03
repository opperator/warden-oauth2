require 'warden-oauth2'

module Warden
  module OAuth2
    module Strategies
      class Bearer < Token
        def valid?
          !!token_string
        end

        def token_string
          token_string_from_header || token_string_from_request_params
        end

        def token_string_from_header
          Rack::Auth::AbstractRequest::AUTHORIZATION_KEYS.each do |key|
            if env.key?(key) && token_string = env[key][/^Bearer (.*)/, 1]
              return token_string
            end
          end
          nil
        end

        def token_string_from_request_params
          params[:access_token]
        end
      end
    end
  end
end
