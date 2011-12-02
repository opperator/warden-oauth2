require 'warden-oauth2'

module Warden
  module OAuth2
    module Strategies
      class Token < Warden::Strategies::Base
        def authenticate!
          fail "Invalid access token." and return unless token
          success! token
        end

        def token
          raise NotImplementedError
        end
      end
    end
  end
end
