require 'warden-oauth2'
require 'base64'

module Warden
  module OAuth2
    module Strategies
      class Client < Warden::Strategies::Base
        attr_reader :client, :client_id, :client_secret

        def authenticate!
          @client = client_from_http_basic || client_from_request_params

          if self.client
            fail "Insufficient scope." and return if scope && client.respond_to?(:scope) && !client.scope?(scope)
            success! self.client, "Authorized with client credentials."
          else
            fail "No client credentials provided."
          end
        end

        def client_from_http_basic
          return nil unless (env.keys & Rack::Auth::AbstractRequest::AUTHORIZATION_KEYS).any?
          @client_id, @client_secret = *Rack::Auth::Basic::Request.new(env).credentials
          Warden::OAuth2.config.client_model.locate(self.client_id, self.client_secret)
        end

        def client_from_request_params
          @client_id, @client_secret = params[:client_id], params[:client_secret]
          return nil unless self.client_id
          Warden::OAuth2.config.client_model.locate(@client_id, @client_secret)
        end

        def public_client?
          client && !client_secret
        end
      end
    end
  end
end
