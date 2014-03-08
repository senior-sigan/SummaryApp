require 'spec_helper'

describe ParticipantFactory do
  it 'generate email' do
    expect(
      ParticipantFactory.generate_email('name', 'surname')
    ).to eq 'name.surname@summaryapp.heroku.com'

    expect(
      ParticipantFactory.generate_email('', 'surname')
    ).to be_nil

    expect(
      ParticipantFactory.generate_email('name', '')
    ).to be_nil
  end
end