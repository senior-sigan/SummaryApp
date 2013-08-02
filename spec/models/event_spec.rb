require 'spec_helper'

describe Event do
  before { @event = FactoryGirl.create :event }

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:users) }
  it { should respond_to(:categories) }
  it { should respond_to(:invite!) }
  it { should respond_to(:exclude!) }

##### ONLY FOR MONGOID ##########
  it { should have_field(:name).of_type(String)}
  it { should have_field(:date).of_type(DateTime)}
  it { should have_field(:place).of_type(String)}
  it { should have_many(:participations).with_foreign_key(:event_id)}
  it { should validate_presence_of :name }
  it { should validate_presence_of :date }
  it { should validate_uniqueness_of(:name).case_insensitive }
#################################  
  
  it { should be_valid }

  describe "inviting user" do
    let(:user) { FactoryGirl.create :user }
    let(:category) { FactoryGirl.create :category }
    let(:score) { 100 }
    before do
      @event.invite!(user,category,score)
    end
    describe "should set right" do
      its(:users) { should be_include(user) }
    end
    describe "should set right" do
      its(:categories) { should be_include(category) }
    end
    describe "and excluding user" do
      before { @event.exclude!(user) }
      its(:users) { should_not be_include(user) }
      its(:categories) { should_not be_include(category) }
    end
  end
end
