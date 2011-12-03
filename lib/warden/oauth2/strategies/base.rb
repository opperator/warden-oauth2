require 'warden-oauth2'

module Warden
  module OAuth2
    module Strategies
      class Base < Warden::Strategies::Base
        def store?
          false
        end

        def error_status
          400
        end
      end
    end
  end
end
