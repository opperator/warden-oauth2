require 'spec_helper'

describe Warden::OAuth2::Strategies::Token do
  let(:token_model){ double }
  let(:strategy){ Warden::OAuth2::Strategies::Token }
  subject{ strategy.new({'rack.input' => {}}) }

  before do
    Warden::OAuth2.config.token_model = token_model
  end

  describe '#token' do
    it 'should call through to .locate on the token_class with the token string' do
      expect(token_model).to receive(:locate){['abc', nil]}
      allow(subject).to receive(:token_string).and_return('abc')
      subject.token
    end
  end

  describe '#authenticate!' do
    it 'should be successful if there is a token' do
      token_instance = double
      allow(subject).to receive(:token).and_return(token_instance)
      subject._run!
      expect(subject.result).to eq(:success)
      expect(subject.user).to eq(token_instance)
    end

    it 'should fail if there is not a token' do
      allow(subject).to receive(:token).and_return(nil)
      subject._run!
      expect(subject.result).to eq(:failure)
      expect(subject.message).to eq("invalid_request")
      expect(subject.error_status).to eq(400)
    end

    it 'should fail if the access token is expired' do
      token_instance = double(:respond_to? => true, :expired? => true, :scope? => true)
      allow(subject).to receive(:token).and_return(token_instance)
      subject._run!
      expect(subject.result).to eq(:failure)
      expect(subject.message).to eq("invalid_token")
      expect(subject.error_status).to eq(401)
    end

    it 'should fail if there is insufficient scope' do
      token_instance = double(:respond_to? => true, :expired? => false, :scope? => false)
      allow(subject).to receive(:token).and_return(token_instance)
      allow(subject).to receive(:scope).and_return(:secret)
      subject._run!
      expect(subject.result).to eq(:failure)
      expect(subject.message).to eq("insufficient_scope")
      expect(subject.error_status).to eq(403)
    end
  end
end
