require 'spec_helper'

describe Registration do
  let(:user) { FactoryGirl.create :user }
  let(:event) { FactoryGirl.create :event }
  before { @registration = FactoryGirl.build :registration, user: user, event: event }

  subject { @registration }

  it { should respond_to :user }
  it { should respond_to :event }
  it { should respond_to :was }
  it { should respond_to :newcomer }

  it { should be_valid }

  describe "when user not present" do
  	before { @registration.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when pair [user_id,event_id] is already taken" do
    before do
      user.registrate_to!(event)
    end

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

  describe "when newcomer not present" do
    before { @registration.newcomer = nil }
    it { should_not be_valid }
  end

  describe "create newcomer" do
    let(:newcomer) { FactoryGirl.create :user }
    let(:first_event) { FactoryGirl.create :event }
    
    before { @first_registration = newcomer.registrate_to!(first_event) }

    subject { @first_registration }
    its(:newcomer) { should eq true }

    describe "create old comer" do
      let(:second_event) { FactoryGirl.create :event }
      before { @second_registration = newcomer.registrate_to!(second_event)}
      subject { @second_registration }
      its(:newcomer) { should_not eq true }
    end
  end
end
