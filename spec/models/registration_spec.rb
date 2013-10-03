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
  it { should respond_to :categories }

  it { should be_valid }

  describe "when user not present" do
  	before { @registration.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when pair [user_id,event_id] is already taken" do
    let(:category) { 'android' }
    let(:score) { 100 }
    
    before do
      user.participate!(event, category, score)
    end

    it { should_not be_valid }
  end

  describe "when event not present" do
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
    let(:category) { 'android' }
    let(:score) { 100 }
    
    before { @first_registration = newcomer.participate!(first_event,category, score ) }

    subject { @first_registration }
    its(:newcomer) { should eq true }

    describe "create old comer" do
      let(:second_event) { FactoryGirl.create :event }
      before { @second_registration = newcomer.participate!(second_event, category, score)}
      subject { @second_registration }
      its(:newcomer) { should_not eq true }
    end
  end
end
