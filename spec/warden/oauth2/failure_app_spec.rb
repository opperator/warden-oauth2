require 'spec_helper'

describe Warden::OAuth2::FailureApp do
  let(:app){ subject }
  let(:warden){ mock(:winning_strategy => @strategy || strategy) }
  let(:strategy){ mock(:message => 'invalid_request') }

  context 'with all info' do
    before do
      @strategy = mock(:error_status => 502, :message => 'custom', :scope => 'random')
      get '/unauthenticated', {}, 'warden' => warden
    end

    it 'should set the status from error_status if there is one' do
      last_response.status.should == 502
    end

    it 'should set the message from the message' do
      last_response.body.should == '{"error":"custom"}'
    end

    it 'should set the content type' do
      last_response.headers['Content-Type'].should == 'application/json'
    end

    it 'should set the X-OAuth-Accepted-Scopes header' do
      last_response.headers['X-Accepted-OAuth-Scopes'].should == 'random'
    end
  end
end
