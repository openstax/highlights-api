require 'rails_helper'

RSpec.describe Highlight, type: :model do
  let(:highlight) { build(:highlight) }

  describe 'creates to db ok' do
    let(:valid_uuid) { Highlight::VALID_UUID }

    before { create(:highlight) }

    it 'has a count of 1 in the db' do
      expect(Highlight.count).to eq 1
    end

    it 'created an id w/ a valid uuid' do
      expect(Highlight.first.id).to match(valid_uuid)
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
        expect(highlight.valid?).to be_truthy

        highlight.color = 'invalid color'
        expect(highlight.valid?).to be_falsey
        expect(highlight.errors[:color]).to include('is invalid')

        highlight.color = '#c0c0c0'
        expect(highlight.valid?).to be_truthy
      end
    end

    context 'generic normalizations' do
      it 'color will be downcased' do
        record = described_class.new(color: '#C0C0C0')
        record.validate
        expect(record.color).to eq '#c0c0c0'
      end
    end

    context 'openstax_page source_type' do
      it 'color will be downcased' do
        record = described_class.new(color: '#C0C0C0')
        record.validate
        expect(record.color).to eq '#c0c0c0'
      end

      it 'scope_id will be downcased' do
        record = described_class.openstax_page.new(scope_id: 'ABC')
        record.validate
        expect(record.scope_id).to eq 'abc'
      end

      it 'source_id will be downcased' do
        record = described_class.openstax_page.new(source_id: 'ABC')
        record.validate
        expect(record.source_id).to eq 'abc'
      end

      context 'source ids' do
        it 'source_id must be a uuid' do
          record = described_class.openstax_page.new(source_id: 'ABC')
          record.validate
          expect(record.errors['source_id']).to eq ['must be a UUID for source_type openstax_page']

          record = described_class.openstax_page.new(source_id: SecureRandom.uuid)
          record.validate
          expect(record.errors['source_id']).to be_empty
        end
        it 'scope_id must be a uuid' do
          record = described_class.openstax_page.new(scope_id: 'ABC')
          record.validate
          expect(record.errors['scope_id']).to eq ['must be a UUID for source_type openstax_page']

          record = described_class.openstax_page.new(scope_id: SecureRandom.uuid)
          record.validate
          expect(record.errors['scope_id']).to be_empty
        end
      end
    end
  end
end
