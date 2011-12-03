require 'spec_helper'

describe Warden::OAuth2::Strategies::Public do
  let(:env){ {'PATH_INFO' => '/resource'} }
  let(:strategy){ Warden::OAuth2::Strategies::Public }
  subject{ strategy.new(env) }

  it 'should succeed with no scope' do
    subject._run!
    subject.result.should == :success
  end

  it 'should succeed with a :public scope' do
    subject.stub!(:scope).and_return(:public)
    subject._run!
    subject.result.should == :success
  end

  it 'should fail and halt with another scope' do
    subject.stub!(:scope).and_return(:user)
    subject._run!
    subject.should be_halted
    subject.message.should == "insufficient_scope"
    subject.result.should == :failure
  end
end
