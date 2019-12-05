require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#increment_num_highlights' do
    let!(:user) { create(:user, num_highlights: 5) }

    it 'didnt allow a negative number in the num highlights count' do
      expect(Rails.logger).to receive(:error)
      user.increment_num_highlights(by: -10)
      expect(user.reload.num_highlights).to be_zero
    end
  end

  describe '#increment_num_annotation_characters' do
    let!(:user) { create(:user, num_annotation_characters: 5) }

    it 'didnt allow a negative number in the num annotation characters count' do
      expect(Rails.logger).to receive(:error)
      user.increment_num_annotation_characters(by: -10)
      expect(user.reload.num_annotation_characters).to be_zero
    end
  end
end
