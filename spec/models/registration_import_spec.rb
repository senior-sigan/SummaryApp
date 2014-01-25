require 'spec_helper'

describe RegistrationImport do
  let(:file) { FactoryGirl.build :good_file }
  let(:event) { FactoryGirl.create :event }
  before { @import = RegistrationImport.new({file: file, fields: [].to_json, event: event}) }

  subject { @import }

  it { should respond_to(:file) }
  it { should respond_to(:save) }
  it { should respond_to(:errors) }

  it { should be_valid }

  describe "when file not present" do
    before { @import.file = nil }
    it { should_not be_valid }
  end

#  describe "when Participation in file is invalid" do
#  	before { @import.file = "Some crazy stuff" } # TODO - real csv with crazy rows
#  	it { should_not be_valid }
#  end

#  describe "when Participation in file is valid" do
#  	before { @import.file = "Some true stuff" } # TODO - real csv with true rows
#  	it { should be_valid }
#  end

  describe "when import new 42 Users" do
    let(:file_2) { FactoryGirl.build :good_file }
    let(:event_2) { FactoryGirl.create :event }
    let(:import_2) { RegistrationImport.new({fields: %w(email name surname).to_json, event: event_2, file: file_2}) }

    before do
      import_2.save
    end

    subject { event_2.participants }
    its(:count) { should eq 42 }
  end
end