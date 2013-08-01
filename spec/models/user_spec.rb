require 'spec_helper'

describe User do
  before { @user = FactoryGirl.create :user }

  subject { @user }


  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:surname) }
  it { should respond_to(:participations) }
  it { should respond_to(:events) }
  it { should respond_to(:categories) }

  it { should respond_to(:participate!) }
  it { should respond_to(:leave!) }
  it { should respond_to(:score) }

##### ONLY FOR MONGOID ##########
  it { should have_field(:email).of_type(String)}
  it { should have_field(:name).of_type(String)}
  it { should have_field(:surname).of_type(String)}
  it { should have_many(:participations).with_foreign_key(:user_id)}
#################################
  it { should be_valid }

  describe "participating in event" do
    let(:event) { FactoryGirl.create :event }
    let(:category) { FactoryGirl.create :category }
    let(:score) { 100 }
    before do
      @user.save
      @user.participate(event, category, score)
    end
    describe "should set right" do
      its(:events) { should include(event) }
    end
    describe "should set right" do
      its(:categories) { should include(category) }
    end
    describe "should set right" do
      its(:score) { should eq 100 }
    end
    describe "and leaving event" do
      before { @user.leave!(event) }
      describe "should minus" do
        its(:events) { should_not include(event) }
      end
      describe "should minus" do
        its(:score) { should_not eq 100 }
      end
      describe "should remove" do
        its(:categories) { should_not include(category) }
      end
    end
  end

  describe "when name is not present" do 
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do 
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when surname is not present" do 
  	before { @user.surname = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @user.name = "a"*51 }
  	it { should_not be_valid }
  end
  describe "when surname is too long" do
  	before { @user.name = "a"*51 }
  	it { should_not be_valid }
  end
  describe "when email is too long" do
  	before { @user.name = "a"*101 }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email is already taken" do
    let(:user_with_same_email) { @user.dup }
  	before do 
  	  user_with_same_email.email.upcase!
  	  user_with_same_email.save
  	end

  	it { user_with_same_email.should_not  be_valid }
  end

  describe "when create dynamic attributes" do
  	before do
  	  multy_user = User.new(email: "mu@aa.a", name: "mu", surname: "muatr", some_dynamic_attribute: "attribute")
  	  multy_user.save
  	end

  	it { should be_valid }
  end
end
