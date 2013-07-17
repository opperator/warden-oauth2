require 'warden-oauth2'

module Warden
  module OAuth2
    module Strategies
      class Public < Base
        def authenticate!
          if scope && scope.to_sym != :public
            fail! "insufficient_scope" and return
          end
          
          unless Warden::OAuth2.config.public_model
            success! 'public' 
          else
            success! Warden::OAuth2.config.public_model.new
          end
        end

        def error_status
          401
        end
      end
    end
  end
end
