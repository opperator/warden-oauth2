require 'spec_helper'

describe Warden::OAuth2::Strategies::Public do
  let(:env){ {'PATH_INFO' => '/resource'} }
  let(:strategy){ Warden::OAuth2::Strategies::Public }
  subject{ strategy.new(env) }

  it 'should succeed with no scope' do
    subject._run!
    expect(subject.result).to eq(:success)
  end

  it 'should succeed with a :public scope' do
    allow(subject).to receive(:scope).and_return(:public)
    subject._run!
    expect(subject.result).to eq(:success)
  end

  it 'should fail and halt with another scope' do
    allow(subject).to receive(:scope).and_return(:user)
    subject._run!
    expect(subject).to be_halted
    expect(subject.message).to eq("insufficient_scope")
    expect(subject.result).to eq(:failure)
  end
end
