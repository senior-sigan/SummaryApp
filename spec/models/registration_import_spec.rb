require 'spec_helper'

describe RegistrationImport do
  let(:file) { FactoryGirl.build :good_file }
  let(:event) { FactoryGirl.create :event }
  before { @import = RegistrationImport.new({file: file, black_list: [], attributes_map: {}, event: event}) }

  subject { @import }

  it { should respond_to(:file) }
  it { should respond_to(:save) }
  it { should respond_to(:errors) }

  it { should be_valid }

  describe "when file not present" do
    before { @import.file = nil }
    it { should_not be_valid }
  end

  describe "when event not present" do
    before { @import.event = nil }
    it { should_not be_valid }
  end

  context 'when import with flag do not build new' do
    let(:file_1) { FactoryGirl.build(:good_file) }
    let(:file_2) { FactoryGirl.build(:next_good_file) }
    let(:event) { FactoryGirl.build(:event) }
    let(:import_1) { RegistrationImport.new({event: event, file: file_1}) }
    let(:import_2) { RegistrationImport.new({event: event, file: file_2, build_new: false }) }

    before do
      import_1.save
      @count = event.participants.count
    end

    describe 'import second file' do
      before do
        import_2.save
      end

      subject { event.participants }
      its(:count) { should be_eql @count }
    end
  end

  describe "when Participation in file is not valid" do
    let(:bad_file) { FactoryGirl.build(:bad_participants_file) }
    let(:event) { FactoryGirl.create :event }
    let(:import) { RegistrationImport.new({event: event, file: bad_file}) }

    subject { import }
  	it { should_not be_valid }
  end

  describe 'when csv with wrong row length' do
    let(:bad_file) { FactoryGirl.build :bad_row_length_file }
    let(:event) { FactoryGirl.create :event }
    let(:import) { RegistrationImport.new({event: event, file: bad_file}) }

    subject { import }
    it { should_not be_valid }
  end

  describe "when import new 42 Participants" do
    let(:file_2) { FactoryGirl.build :good_file }
    let(:event_2) { FactoryGirl.create :event }
    let(:import_2) { RegistrationImport.new({event: event_2, file: file_2}) }

    before do
      import_2.save
    end

    subject { event_2.participants }
    its(:count) { should eq 42 }
  end
end