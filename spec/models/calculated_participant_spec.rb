require 'spec_helper'

describe CalculatedParticipant do
  before { @part = CalculatedParticipant.new }
  subject { @part }

  it { should respond_to(:value) }

  describe 'recalculate do map reduce on Event'
    let(:event) { FactoryGirl.build :event_with_participants }

    before do 
      event.save
      CalculatedParticipant.recalculate
    end

  end
end
