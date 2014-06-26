require 'rails_helper'

RSpec.describe Event, :type => :model do
  let(:event) { FactoryGirl.create :event }
  subject { event }

  it { should respond_to :name }
  it { should respond_to :date }
  it { should respond_to :photo_url }
  it { should respond_to :social_url }
  it { should respond_to :hash_tag }

  it { should respond_to :records }

  it { should be_valid }

  describe "when name is not present" do 
    before { event.name = " " }
    it { should_not be_valid }
  end

  describe "when date is not present" do 
    before { event.date = " " }
    it { should_not be_valid }
  end

  describe "when name is to long" do 
    before { event.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when photo_url is to long" do 
    before { event.photo_url = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when social_url is to long" do 
    before { event.social_url = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when photo_url is to long" do 
    before { event.hash_tag = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    let(:event_with_same_name) { event.dup }
    before do
      event_with_same_name.name.upcase!
      event_with_same_name.save
    end

    it { event_with_same_name.should_not  be_valid }
  end
end
