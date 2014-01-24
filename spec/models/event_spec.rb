require 'spec_helper'

describe Event do
  before { @event = FactoryGirl.create :event }

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:participants) }
  it { should respond_to(:newcomers) }
  it { should respond_to(:categories) }

  it { should be_valid }

  describe "categories method" do
    let(:participant) { FactoryGirl.build :participant }
    let(:category_1) { FactoryGirl.build :category, name: 'android' }
    let(:category_2) { FactoryGirl.build :category, name: 'windows' }
    let(:category_3) { FactoryGirl.build :category, name: 'ios' }
    let(:event) { FactoryGirl.build :event }  

    before do
      participant.categories << category_1
      participant.categories << category_2
      event.participants << participant
      event.save
    end

    subject { event }

    its(:participants) { should be_include participant }
    its(:categories) { should be_include category_1 }
    its(:categories) { should be_include category_2 }
    its(:categories) { should_not be_include category_3 }
  end
  
  describe "when come newcomers they NEW" do
    let(:first_event) { FactoryGirl.create :event }
    let(:user) { FactoryGirl.create :user }
    let(:category) { 'android' }
    let(:score) { 100 }

    before { user.participate!(first_event, category, score) }

    subject { first_event }
    its(:newcomers) { should be_include(user) }

    describe "when come oldcomers they OLD" do
      let(:second_event) { FactoryGirl.create :event }

      before { user.participate!(second_event, category, score) }
  
      subject { second_event }
      its(:newcomers) { should_not be_include(user) }
    end

    describe "categories" do
      let(:category_2) { 'win8' }

      before { user.participate!(first_event, category_2, score) }

      its(:categories) { should be_include(category) }
      its(:categories) { should be_include(category_2) }
    end
  end
end
