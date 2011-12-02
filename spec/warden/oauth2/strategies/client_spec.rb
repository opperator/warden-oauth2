require 'spec_helper'

describe Warden::OAuth2::Strategies::Client do
  let(:strategy){ Warden::OAuth2::Strategies::Client }
  let(:client_model){ mock(:ClientApplication) }
  subject{ strategy.new({'rack.input' => {}}) }

  before do
    Warden::OAuth2.config.client_model = client_model
  end

  describe '#client_from_http_basic' do
    it 'should call through to the client application class locate method' do
      subject.stub!(:env).and_return({
        'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64('id:secret')}"
      })

      client_model.should_receive(:locate).with('id','secret').and_return("booya")
      subject.client_from_http_basic.should == "booya"
    end

    it 'should return nil if no HTTP Basic credentials are provided' do
      subject.client_from_http_basic.should be_nil
    end
  end

  describe '#client_from_request_params' do
    it 'should be nil if no client_id is provided' do
      subject.stub!(:params).and_return({:client_secret => 'abc'})
      subject.client_from_request_params.should be_nil
    end

    it 'should call through to locate if a client_id is present' do
      subject.stub!(:params).and_return({:client_id => 'abc'})
      client_model.should_receive(:locate).with('abc',nil)
      subject.client_from_request_params
    end

    it 'should call through to locate if a client_id and secret are present' do
      subject.stub!(:params).and_return({:client_id => 'abc', :client_secret => 'def'})
      client_model.should_receive(:locate).with('abc','def')
      subject.client_from_request_params
    end
  end

  describe '#authorize!' do
    it 'should succeed if a client is around' do
      client_instance = mock
      client_model.stub!(:locate).and_return(client_instance)
      subject.stub!(:params).and_return(:client_id => 'awesome')
      subject._run!
      subject.user.should == client_instance
      subject.result.should == :success
    end

    it 'should fail if no credentials are passed' do
      subject._run!
      subject.result.should == :failure
      subject.message.should == "No client credentials provided."
    end

    it 'should fail if it requires a confidential client but no secret is passed' do
      client_model.stub!(:locate).and_return(mock)
      subject.stub!(:params).and_return(:client_id => 'abc')
      subject.stub!(:scope).and_return(:confidential_client)
      subject._run!
      subject.result.should == :failure
      subject.message.should == "A confidential client is required to access this resource."
    end
  end
end
