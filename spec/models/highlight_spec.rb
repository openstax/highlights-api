require 'rails_helper'

RSpec.describe Highlight, type: :model do
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
  end
end
