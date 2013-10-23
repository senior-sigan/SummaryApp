require 'spec_helper'

describe Participant do
  before { @participant = FactoryGirl.create :participant }

  subject { @participant }


  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:surname) }
  it { should respond_to(:event) }
  it { should respond_to(:categories) }

  it { should respond_to(:score) }

##### ONLY FOR MONGOID ##########
  it { should have_field(:email).of_type(String)}
  it { should have_field(:name).of_type(String)}
  it { should have_field(:surname).of_type(String)}
#################################
  it { should be_valid }

  describe "participating in event" do
    let(:event) { FactoryGirl.create :event }
    let(:category) { 'android' }
    let(:score) { 100 }
    before do
      @participant.save
      event.save
      @participant.participate!(event, category, score)
    end

    describe "should set right" do
      its(:events) { should be_include(event) }
      its(:categories) { should be_include(category) }
      its(:score) { should eq 100 }
    end

    describe "set fake for event" do
      let(:registration) { @participant.registrations.where(event: event).last }
      before do 
        @participant.set_fake_for(event)
      end

      its(:real_registrations) { should_not be_include(registration) }
      its(:fake_registrations) { should be_include(registration) }
    end

    describe "and leaving event" do
      before { @participant.leave!(event) }

      its(:score) { should_not eq 100 }
      its(:events) { should_not be_include(event) }
      its(:categories) { should_not be_include(category) }
    end
  end

  describe "when name is not present" do 
  	before { @participant.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do 
  	before { @participant.email = " " }
  	it { should_not be_valid }
  end

  describe "when surname is not present" do 
  	before { @participant.surname = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @participant.name = "a"*51 }
  	it { should_not be_valid }
  end
  describe "when surname is too long" do
  	before { @participant.name = "a"*51 }
  	it { should_not be_valid }
  end
  describe "when email is too long" do
  	before { @participant.name = "a"*101 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[participant@foo,com participant_at_foo.org example.participant@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @participant.email = invalid_address
        expect(@participant).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[participant@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @participant.email = valid_address
        expect(@participant).to be_valid
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @participant.email = mixed_case_email
      @participant.save
      expect(@participant.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email is already taken" do
    let(:participant_with_same_email) { @participant.dup }
  	before do 
  	  participant_with_same_email.email.upcase!
  	  participant_with_same_email.save
  	end

  	it { participant_with_same_email.should_not  be_valid }
  end

  describe "when create dynamic attributes" do
  	before do
  	  multy_participant = participant.new(email: "mu@aa.a", name: "mu", surname: "muatr", some_dynamic_attribute: "attribute")
  	  multy_participant.save
  	end

  	it { should be_valid }
  end
end
