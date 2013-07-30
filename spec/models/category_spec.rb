require 'spec_helper'

describe Category do
  before { @category = FactoryGirl.create :category }

  subject { @category }

  it { should have_field(:isPublic).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:name).of_type(String)}
  it { should have_many(:participations).with_foreign_key(:category_id)}

  it { should be_valid }

  describe "when name is not present" do 
  	before { @category.name = " " }
  	it { should_not be_valid }
  end

  describe "when isPublic is not present" do 
    before { @category.isPublic = " " }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    let(:category_with_same_name) { @category.dup }
    before do 
      category_with_same_name.name.upcase!
      category_with_same_name.save
    end

    it { category_with_same_name.should_not  be_valid }
  end
  
end
