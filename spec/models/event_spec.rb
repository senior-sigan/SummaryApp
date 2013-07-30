require 'spec_helper'

describe Event do
  before { @event = Event.new(name: "Gdg", date: "20.06.13", place: "Somewhere") }

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:date) }
  it { should respond_to(:place) }

  it { should respond_to(:users) }

  it { should be_valid }

  describe "when name is not present" do 
  	before { @event.name = " " }
  	it { should_not be_valid }
  end

  describe "when date is not present" do 
  	before { @event.date = " " }
  	it { should_not be_valid }
  end

  describe "when name is already taken" do
  	before do 
  	  event_with_same_name = @event.dup
  	  event_with_same_name.name = @event.name.upcase
  	  event_with_same_name.save
  	end

  	it { should_not  be_valid }
  end

  describe "name with mixed case" do
    let(:mixed_case_name) { "AnDrOiDdevFest" }

    it "should be saved as all lower-case" do
      @event.name = mixed_case_name
      @event.save
      expect(@event.reload.name).to eq mixed_case_name.downcase
    end
  end
end
