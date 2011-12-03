require 'warden-oauth2'

module Warden
  module OAuth2
    class ErrorApp
      def self.call(env)
        new.call(env)
      end

      def call(env)
        warden = env['warden']
        strategy = warden.winning_strategy
        status = strategy.respond_to?(:error_status) ? strategy.error_status : 401
        headers = {'Content-Type' => 'application/json'}
        headers['X-Accepted-OAuth-Scopes'] = (strategy.scope || :public).to_s
        body = "{\"error\":\"#{strategy.message}}"

        Rack::Response.new(body, status, headers).finish
      end
    end
  end
end
