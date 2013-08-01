require 'spec_helper'

describe Participation do
  let(:user) { FactoryGirl.create :user }
  let(:event) { FactoryGirl.create :event }
  let(:category) { FactoryGirl.create :category }
  let(:participation) { FactoryGirl.create :participation, user: user, event: event, category: category }

  subject { participation }

  it { should be_valid }

  it { should validate_presence_of :score }
  it { should validate_numericality_of :score }
  it { should belong_to(:user).of_type(User) }
  it { should belong_to(:event).of_type(Event) }
  it { should belong_to(:category).of_type(Category) }

  describe "when user_id is not present" do
    before { participation.user_id = nil }
    it { should_not be_valid }
  end

  describe "when event_id is not present" do
    before { participation.event_id = nil }
    it { should_not be_valid }
  end

  describe "when category_id is not present" do
    before { participation.category_id = nil }
    it { should_not be_valid }
  end

  describe "user method" do
    it { should respond_to(:user) }
    its(:user) { should eq user}
  end

  describe "category method" do
    it { should respond_to(:category) }
    its(:category) { should eq category}
  end

  describe "event method" do
    it { should respond_to(:event) }
    its(:event) { should eq event}
  end
end