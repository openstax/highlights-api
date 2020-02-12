require 'rails_helper'

RSpec.describe HighlightsInfo, type: :service do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:yet_another_user) { create(:user) }
  let!(:highlight1) { create(:highlight, user_id: user.id, annotation: 'Spoonman') }
  let!(:highlight2) { create(:highlight, user_id: user.id, annotation: 'Come as you are') }
  let!(:highlight3) { create(:highlight, user_id: user.id, annotation: 'Burden in my hand') }
  let!(:highlight4) { create(:highlight, user_id: another_user.id, annotation: "hi there") }

  describe '#call' do
    let(:info_results) { subject.call }

    it 'returns the correct number of total highlights' do
      expect(info_results[:data][:total_highlights]).to eq 4
    end

    it 'returns the correct average highlights per user' do
      expect(info_results[:data][:avg_highlights_per_user]).to eq 2
    end

    it 'returns the correct number of total users' do
      expect(info_results[:data][:total_users]).to eq 3
    end

    it 'returns the correct number of users with highlights' do
      expect(info_results[:data][:num_users_with_highlights]).to eq 2
    end

    it 'returns the correct number of users with notes' do
      expect(info_results[:data][:num_users_with_notes]).to eq 2
    end

    it 'returns the correct total_notes' do
      expect(info_results[:data][:total_notes]).to eq 4
    end

    it 'returns the correct average note length' do
      expect(info_results[:data][:avg_note_length]).to eq 13
    end
  end
end
