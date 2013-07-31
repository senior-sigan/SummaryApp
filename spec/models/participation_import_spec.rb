require 'spec_helper'

describe ParticipationImport do
  before { @import = ParticipationImport.new }

  subject { @import }

  it { should respond_to(:file) }
  it { should respond_to(:save) }
  it { should respond_to(:errors) }

  it { should be_valid }

  describe "when Participation in file is invalid" do
  	before { @import.file = "Some crazy stuff" } # TODO - real csv with crazy rows
  	it { should_not be_valid }
  end

  describe "when Participation in file is valid" do
  	before { @import.file = "Some true stuff" } # TODO - real csv with true rows
  	it { should be_valid }
  end

  describe "when User not exists it creates new one" do
  	#TODO
  end

  describe "when User exists it updates this one" do
  	#TODO
  end 

end