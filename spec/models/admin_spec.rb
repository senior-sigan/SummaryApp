require 'rails_helper'

RSpec.describe Admin, :type => :model do
  let(:admin) { FactoryGirl.create :admin }
  subject { admin }

  it { should respond_to :email }
  it { should respond_to :authentication_token }
  it { should respond_to :approved }

  it { should be_valid }
  it { should_not be_approved }

  describe "when email is not present" do 
    before { admin.email = " " }
    it { should_not be_valid }
  end

  describe "when email is too long" do
    before { admin.email = "a"*101 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[participant@foo,com participant_at_foo.org example.participant@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        admin.email = invalid_address
        expect(admin).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[participant@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        admin.email = valid_address
        expect(admin).to be_valid
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      admin.email = mixed_case_email
      admin.save
      expect(admin.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "when email is already taken" do
    let(:admin_with_same_email) { FactoryGirl.build :admin, email: admin.email }

    it { admin_with_same_email.should_not  be_valid }
  end

  describe "when token is already taken" do
    let(:admin_with_same_token) { FactoryGirl.build :admin, authentication_token: admin.authentication_token }

    it { admin_with_same_token.should_not  be_valid }
  end
end
