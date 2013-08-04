require 'spec_helper'

describe Participation do
  let(:user) { FactoryGirl.create :user }
  let(:event) { FactoryGirl.create :event }
  let(:category) { FactoryGirl.create :category }
  let(:registration) { FactoryGirl.create :registration, user: user, event: event }
  let(:participation) { FactoryGirl.create :participation, registration: registration, category: category, score: 10 }

  subject { participation }

  it { should be_valid }

  it { should validate_presence_of :score }
  it { should validate_numericality_of :score }
  it { should belong_to(:registration).of_type(Registration) }
  it { should belong_to(:category).of_type(Category) }

  describe "when registration_id is not present" do
    before { participation.registration_id = nil }
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