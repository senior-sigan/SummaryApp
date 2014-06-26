require 'rails_helper'

RSpec.describe RecordBuilder do
  let(:event) { FactoryGirl.create :event }
  let(:existing_record) { FactoryGirl.create :record }
  let(:builder) { RecordBuilder.new({
    email: 'benjamin.peterson68@example.com', 
    name: 'benjamin', 
    surname: 'peterson'})}
  subject { builder }

  it { should respond_to :build_for }

  describe 'when all params right' do
    let(:record) { builder.build_for(event) }
    subject { record }

    it { should be_valid }
    it 'save params' do
      record.email.should be_eql 'benjamin.peterson68@example.com'
      record.name.should be_eql 'benjamin'
      record.surname.should be_eql 'peterson'
    end
  end

  describe 'when email not presence' do
    before { builder.email = nil }

    describe 'when there is no records with the same name and surname' do
      let(:record) { builder.build_for(event) }
      subject { record }

      it { should be_valid }
      it 'generate email from name and surname' do
        record.email.should be_eql "benjamin.peterson@#{RecordBuilder::DOMAIN}"
      end
    end

    describe 'when there is exists records with the same name and surname' do
      before {
        builder.name = existing_record.name
        builder.surname = existing_record.surname
      }      
      let(:record) { builder.build_for(event) }
      subject { record }

      it { should be_valid }
      it 'get email from existing record finded by name and surname' do
        record.email.should be_eql existing_record.email
      end
    end
  end

  describe 'when name or surname not presence' do
    before {
      builder.name = nil
      builder.surname = nil
    }

    describe 'when there is records with the same email' do
      before { builder.email = existing_record.email }
      let(:record) { builder.build_for(event) }
      subject { record }

      it { should be_valid }
      it 'get name and surname from existing record finded by email' do
        record.name = existing_record.name
        record.surname = existing_record.surname
      end
    end

    describe 'when there is no record with the same email' do
      let(:record) { builder.build_for(event) }
      subject { record }

      it { should_not be_valid }
    end
  end
end