require 'rails_helper'

RSpec.describe HighlightsInfo, type: :service do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:yet_another_user) { create(:user) }
  let(:page_id) { SecureRandom.uuid }
  let!(:highlight1) { create(:highlight, user_id: user.id, source_id: page_id, annotation: 'grass') }
  let!(:highlight2) { create(:highlight, user_id: user.id, prev_highlight_id: highlight1.id, source_id: page_id, annotation: 'the cow jumped') }
  let!(:highlight3) { create(:highlight, user_id: user.id, prev_highlight_id: highlight2.id, source_id: page_id, annotation: 'the cow ate all the grass') }
  let!(:highlight4) { create(:highlight, user_id: another_user.id, annotation: "moo") }
  let!(:highlight5) { create(:highlight, user_id: yet_another_user.id, annotation: "there were many cows eating all the grass") }

  describe '#call' do
    let(:info_results) { subject.call }

    before do
      @prev = reset_constant(const_name: 'GREATER_THAN_200', value: 2)
    end

    after do
      reset_constant(const_name: 'GREATER_THAN_200', value: @prev)
    end

    it 'returns the correct number of total highlights' do
      expect(info_results[:data][:total_highlights]).to eq 5
    end

    it 'returns the correct average highlights per user' do
      expect(info_results[:data][:avg_highlights_per_user]).to eq 1
    end

    it 'returns the correct number of total users' do
      expect(info_results[:data][:total_users]).to eq 3
    end

    it 'returns the correct number of users with highlights' do
      expect(info_results[:data][:num_users_with_highlights]).to eq 3
    end

    it 'returns the correct number of users with notes' do
      expect(info_results[:data][:num_users_with_notes]).to eq 3
    end

    it 'returns the correct total_notes' do
      expect(info_results[:data][:total_notes]).to eq 5
    end

    it 'returns the correct average note length' do
      expect(info_results[:data][:avg_note_length]).to eq 18
    end

    it 'returns the correct median note length' do
      expect(info_results[:data][:median_note_length]).to eq 15
    end

    it 'returns the correct max note length' do
      expect(info_results[:data][:max_note_length]).to eq 42
    end

    it 'returns the correct num users greater than 200 (stubbed as 2)' do
      expect(info_results[:data][:num_users_gt_200_highlights_per_page]).to eq 1
    end
  end

  def reset_constant(const_name:, value:)
    prev_value = HighlightsInfo.const_get(const_name)
    HighlightsInfo.send('remove_const', const_name)
    HighlightsInfo.const_set(const_name, value)
    prev_value
  end
end
