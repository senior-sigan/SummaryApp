require 'rails_helper'

RSpec.describe Record, :type => :model do
  let(:record) { FactoryGirl.create :record }
  subject { record }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:surname) }
  it { should respond_to(:meta) }
  it { should respond_to(:event) }

  it { should be_valid }

  describe "when name is not present" do 
    before { record.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do 
    before { record.email = " " }
    it { should_not be_valid }
  end

  describe "when surname is not present" do 
    before { record.surname = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { record.name = "a"*51 }
    it { should_not be_valid }
  end
  describe "when surname is too long" do
    before { record.name = "a"*51 }
    it { should_not be_valid }
  end
  describe "when email is too long" do
    before { record.name = "a"*101 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[participant@foo,com participant_at_foo.org example.participant@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        record.email = invalid_address
        expect(record).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[participant@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        record.email = valid_address
        expect(record).to be_valid
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      record.email = mixed_case_email
      record.save
      expect(record.reload.email).to eq mixed_case_email.downcase
    end
  end

  describe "name with mixed case" do
    let(:mixed_case_name) { "HaPPy" }

    it "should be saved as all lower-case" do
      record.name = mixed_case_name
      record.save
      expect(record.reload.name).to eq mixed_case_name.downcase
    end
  end

  describe "surname with mixed case" do
    let(:mixed_case_surname) { "NiCe9" }

    it "should be saved as all lower-case" do
      record.surname = mixed_case_surname
      record.save
      expect(record.reload.surname).to eq mixed_case_surname.downcase
    end
  end

  describe "when email is already taken" do
    let(:record_with_same_email) { record.dup }
    before do
      record_with_same_email.email.upcase!
      record_with_same_email.save
    end

    it { record_with_same_email.should_not  be_valid }
  end
end
