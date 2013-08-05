require 'spec_helper'

describe Registration do
  before { @registration = FactoryGirl.create :registration }

  subject { @registration }

  it { should respond_to :user }
  it { should respond_to :event }
  it { should respond_to :was }

  it { should be_valid }

  describe "when user not present" do
  	before { @registration.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when evetn not present" do
  	before { @registration.event_id = nil }
  	it { should_not be_valid }
  end  	

  describe "when was not present" do
  	before { @registration.was = nil }
  	it { should_not be_valid }
  end  	
end
