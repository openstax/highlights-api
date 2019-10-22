require 'rails_helper'

RSpec.describe Highlight, type: :model do
  let(:highlight) { build(:highlight) }

  describe 'creates to db ok' do
    before { create(:highlight) }

    it 'has a count of 1 in the db' do
      expect(Highlight.count).to eq 1
    end
  end

  describe 'validations' do
    describe '#source_type' do
      it 'must be a valid enum' do
        expect { described_class.new(source_type: 'invalid source_type') }
          .to raise_exception(ArgumentError)

        record = described_class.new(source_type: :openstax_page)
        expect(record.valid?).to be_falsey
        expect(record.errors[:source_type]).to_not include('is invalid')
      end
    end

    describe '#color' do
      it 'must be hex' do
        record = described_class.new(color: 'invalid color')
        expect(record.valid?).to be_falsey
        expect(record.errors[:color]).to include('is invalid')

        record = described_class.new(color: '#C0C0C0')
        expect(record.valid?).to be_truthy
        expect(record.errors[:color]).to_not include('is invalid')
      end
    end

    describe '#user_uuid' do
      let(:invalid_user_uuid) { 'foobar' }
      let(:foobar_highlight) { build(:highlight, user_uuid: invalid_user_uuid) }

      it 'must be a uuid' do
        expect(foobar_highlight.user_uuid).to be_nil
      end
    end
  end
end
