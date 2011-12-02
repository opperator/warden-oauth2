require 'warden-oauth2'

module Warden
  module OAuth2
    module Strategies
      class Public < Warden::Strategies::Base
        def authenticate!
          if scope && scope.to_sym != :public
            fail! "The requested resource requires a '#{scope}' authorization scope." and return
          end

          success! nil
        end
      end
    end
  end
end
