require 'spec_helper'

describe Warden::OAuth2::Strategies::Client do
  let(:strategy){ Warden::OAuth2::Strategies::Client }
  let(:client_model){ double(:ClientApplication) }
  subject{ strategy.new({'rack.input' => {}}) }

  before do
    Warden::OAuth2.config.client_model = client_model
  end

  describe '#client_from_http_basic' do
    it 'should call through to the client application class locate method' do
      allow(subject).to receive(:env).and_return({
        'HTTP_AUTHORIZATION' => "Basic #{Base64.encode64('id:secret')}"
      })

      expect(client_model).to receive(:locate){['id','secret']}.and_return("booya")
      expect(subject.client_from_http_basic).to eq("booya")
    end

    it 'should return nil if no HTTP Basic credentials are provided' do
      expect(subject.client_from_http_basic).to eq(nil)
    end
  end

  describe '#client_from_request_params' do
    it 'should be nil if no client_id is provided' do
      allow(subject).to receive(:params).and_return({:client_secret => 'abc'})
      expect(subject.client_from_request_params).to eq(nil)
    end

    it 'should call through to locate if a client_id is present' do
      allow(subject).to receive(:params).and_return({"client_id" => 'abc'})
      expect(client_model).to receive(:locate) {['abc', nil]}
      subject.client_from_request_params
    end

    it 'should call through to locate if a client_id and secret are present' do
      allow(subject).to receive(:params).and_return({"client_id" => 'abc', "client_secret" => 'def'})
      expect(client_model).to receive(:locate) {['abc','def']}
      subject.client_from_request_params
    end
  end

  describe '#authorize!' do
    it 'should succeed if a client is around' do
      client_instance = double
      allow(client_model).to receive(:locate).and_return(client_instance)
      allow(subject).to receive(:params).and_return("client_id" => 'awesome')
      subject._run!
      expect(subject.user).to eq(client_instance)
      expect(subject.result).to eq(:success)
    end

    it 'should fail if no credentials are passed' do
      subject._run!
      expect(subject.result).to eq(:failure)
      expect(subject.message).to eq("invalid_client")
      expect(subject.error_status).to eq(401)
    end

    it 'should fail if insufficient scope is provided' do
      allow(client_model).to receive(:locate).and_return(double(:respond_to? => true, :scope? => false))
      allow(subject).to receive(:params).and_return("client_id" => 'abc')
      allow(subject).to receive(:scope).and_return(:confidential_client)
      subject._run!
      expect(subject.result).to eq(:failure)
      expect(subject.message).to eq("insufficient_scope")
      expect(subject.error_status).to eq(403)
    end
  end
end
