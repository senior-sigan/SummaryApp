require 'spec_helper'

describe Category do
  before { @category = FactoryGirl.create :category }

  subject { @category }
  it { should be_valid }

  it { should respond_to(:events) }
  it { should respond_to(:users) }

  it { should have_field(:isPublic).of_type(Boolean).with_default_value_of(false) }
  it { should have_field(:name).of_type(String)}
  it { should have_many(:participations).with_foreign_key(:category_id)}

#  describe "users must be sorted by score" do
#    let(:event) { FactoryGirl.create :event }
#    let(:users) { FactoryGirl.create_list :user, 20 }
#    before do 
#      users.each do |user|
#        user.participate!(event,@category,rand(1..21))
#      end
#    end
#
#    its(:users) { should be_sorted }
#  end

  describe "users for category" do
    let(:event) { FactoryGirl.create :event }
    let(:user) { FactoryGirl.create :user }
    let(:other_event) { FactoryGirl.create :event }
    let(:other_user) { FactoryGirl.create :user }
    let(:score) { 100 }
    before do
      user.participate!(event, @category, score)
    end

    its(:users) { should be_include(user) }
    its(:events) { should be_include(event) }

    its(:users) { should_not be_include(other_user) }
    its(:events) { should_not be_include(other_event) }
  end

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
