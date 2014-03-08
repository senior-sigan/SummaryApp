require 'spec_helper'

describe Event do
  before { @event = FactoryGirl.create :event }

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:participants) }
  it { should respond_to(:newcomers) }
  it { should respond_to(:categories) }
  it { should respond_to(:hash_tag) }
  it { should respond_to(:plus_link) }
  it { should respond_to(:construct_participant) }

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

  describe "construct participant" do
    let(:participant_attr) { FactoryGirl.attributes_for :participant }
   
    describe "when email is precense" do
      let(:participant) { @event.construct_participant(participant_attr[:email], participant_attr[:name], participant_attr[:surname]) }

      subject { participant }
      its(:name) { should be_eql participant_attr[:name] }
      its(:surname) { should be_eql participant_attr[:surname] }
      its(:email) { should be_eql participant_attr[:email].mb_chars.downcase.to_s }
    end

    describe "when email is not precense" do
      let(:participant) { @event.construct_participant(nil, participant_attr[:name], participant_attr[:surname]) }

      subject { participant }
      its(:name) { should be_eql participant_attr[:name] }
      its(:surname) { should be_eql participant_attr[:surname] }
      its(:email) { should be_eql "#{participant_attr[:name].mb_chars.downcase.to_s}.#{participant_attr[:surname].mb_chars.downcase.to_s}@summaryapp.heroku.com" }
    end
  end 
end
