require 'rails_helper'

RSpec.describe UserSource, type: :model do
  describe '#increment_num_highlights' do
    let!(:user_source) { create(:user_source, num_highlights: 5) }

    it 'didnt allow a negative number in the num highlights count' do
      expect(Rails.logger).to receive(:error)
      user_source.increment_num_highlights(by: -10)
      expect(user_source.reload.num_highlights).to be_zero
    end
  end
end
