require 'spec_helper'

describe Warden::OAuth2::FailureApp do
  let(:app){ subject }
  let(:warden){ double(:winning_strategy => @strategy || strategy) }
  let(:strategy){ double(:message => 'invalid_request') }

  context 'with all info' do
    before do
      @strategy = double(:error_status => 502, :message => 'custom', :scope => 'random')
      get '/unauthenticated', {}, 'warden' => warden
    end

    it 'should set the status from error_status if there is one' do
      expect(last_response.status).to eq(502)
    end

    it 'should set the message from the message' do
      expect(last_response.body).to eq('{"error":"custom"}')
    end

    it 'should set the content type' do
      expect(last_response.headers['Content-Type']).to eq('application/json')
    end

    it 'should set the X-OAuth-Accepted-Scopes header' do
      expect(last_response.headers['X-Accepted-OAuth-Scopes']).to eq('random')
    end
  end
end
