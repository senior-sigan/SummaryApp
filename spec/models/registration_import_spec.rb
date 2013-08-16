require 'spec_helper'

describe RegistrationImport do
  let(:file) { FactoryGirl.build :good_file }
  before { @import = RegistrationImport.new(file: file) }

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
    let(:file) { FactoryGirl.build :good_file }
    let(:event) { FactoryGirl.create :event }
    let(:import) { RegistrationImport.new }

    before do 
      import.file = file
      import.event = event
      import.save 
    end

    subject { User }
    its(:count) { should eq 42 }

    subject { event.newcomers }
    its(:count) { should eq 42 }

    describe "and when import again this Users" do
      let(:next_event) { FactoryGirl.create :event }
      before do
        new_import = RegistrationImport.new
        new_import.file = file 
        new_import.event = next_event
        new_import.save 
      end

      describe "they" do
        subject { User }
        its(:count) { should eq 42 }
      end

      describe "necomers" do
        subject { next_event.newcomers }
        its(:count) { should eq 0 }
      end
    end

    describe "and when import again 4 new and 6 old Users" do
      let(:next_event) { FactoryGirl.create :event }
      let(:next_file) { FactoryGirl.build :next_good_file }
      let(:new_import) { RegistrationImport.new }
      before do 
        new_import.file = next_file
        new_import.event = next_event
        new_import.save
      end

      describe "they" do
        subject { User }
        its(:count) { should eq 46 }
      end

      describe "newcomers" do
        subject { next_event.newcomers }
        its(:count) { should eq 4 }
      end
    end
  end

#  describe "when User exists it updates this one" do
  	#TODO
#  end 

end