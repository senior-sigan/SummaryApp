require 'spec_helper'

describe Participation do
  let(:user) { FactoryGirl.create :user }
  let(:event) { FactoryGirl.create :event }
  let(:category) { FactoryGirl.create :category }
  before { @participation = FactoryGirl.create :participation, user: user, event: event, category: category}

  subject { @participation }

  it { should validate_presence_of :score }
  it { should validate_numericality_of :score }
  it { should belong_to(:user).of_type(User) }
  it { should belong_to(:event).of_type(Event) }
  it { should belong_to(:category).of_type(Category) }
end