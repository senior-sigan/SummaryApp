require 'spec_helper'

describe Category do
  before { @category = Category.new(name: "android")}

  subject { @category }

  it { should respond_to(:name) }

  it { should be_valid }

  describe "when name is not present" do 
  	before { @category.name = " " }
  	it { should_not be_valid }
  end
  describe "when name is already taken" do
  	before do 
  	  category_with_same_name = @category.dup
  	  category_with_same_name.name = @category.name.upcase
  	  category_with_same_name.save
  	end

  	it { should_not  be_valid }
  end
  describe "name with mixed case" do
    let(:mixed_case_name) { "AnDrOiD" }

    it "should be saved as all lower-case" do
      @category.name = mixed_case_name
      @category.save
      expect(@category.reload.name).to eq mixed_case_name.downcase
    end
  end
end
