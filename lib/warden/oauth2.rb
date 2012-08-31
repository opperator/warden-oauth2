require 'warden'
require 'warden/oauth2/version'

module Warden
  module OAuth2
    class Configuration
      attr_accessor :client_model, :token_model, :public_model

      def initialize
        self.client_model = ClientApplication if defined?(ClientApplication)
        self.token_model  = AccessToken if defined?(AccessToken)
        self.public_model = PublicAPIConsumer if defined?(PublicAPIConsumer)
      end
    end

    def self.config
      @@config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    autoload :FailureApp, 'warden/oauth2/failure_app'
    module Strategies
      autoload :Base,   'warden/oauth2/strategies/base'
      autoload :Public, 'warden/oauth2/strategies/public'
      autoload :Token,  'warden/oauth2/strategies/token'
      autoload :Client, 'warden/oauth2/strategies/client'
      autoload :Bearer, 'warden/oauth2/strategies/bearer'
    end
  end
end
