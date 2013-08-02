require 'spec_helper'

describe ParticipationImport do
  before { @import = ParticipationImport.new }

  subject { @import }

  it { should respond_to(:file) }
  it { should respond_to(:save) }
  it { should respond_to(:errors) }

  it { should be_valid }

#  describe "when file not present" do 
#    before { @import.file = nil }
#    it { should_not be_valid }
#  end

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
    before do 
      import = ParticipationImport.new
      import.file = file
      import.save 
    end
    subject { User }
    its(:count) { should eq 42 }

    describe "and when import again this Users" do
      before do
        new_import = ParticipationImport.new
        new_import.file = file 
        new_import.save 
      end
      subject { User }
      its(:count) { should eq 42 }
    end

    describe "and when import again 4 new and 6 old" do
      let(:next_file) { FactoryGirl.build :next_good_file }
      before do
        new_import = ParticipationImport.new 
        new_import.file = next_file
        new_import.save
      end
      subject { User }
      its(:count) { should eq 46 }
    end
  end

#  describe "when User exists it updates this one" do
  	#TODO
#  end 

end