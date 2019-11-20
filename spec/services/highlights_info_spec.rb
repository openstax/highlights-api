require 'rails_helper'

RSpec.describe HighlightsInfo, type: :service do
  let(:some_user_uuid) { SecureRandom.uuid }
  let!(:highlight1) { create(:highlight, user_uuid: some_user_uuid, annotation: 'Spoonman') }
  let!(:highlight2) { create(:highlight, user_uuid: some_user_uuid, annotation: 'Come as you are') }
  let!(:highlight3) { create(:highlight, user_uuid: some_user_uuid, annotation: 'Burden in my hand') }
  let!(:highlight4) { create(:highlight, user_uuid: SecureRandom.uuid, annotation: nil) }

  describe '#call' do
    let(:info_results) { subject.call }

    it 'returns the correct number of total highlights' do
      expect(info_results[:data][:total_highlights]).to eq 4
    end

    it 'returns the correct average highlights per user' do
      expect(info_results[:data][:avg_highlights_per_user]).to eq 2
    end

    it 'returns the correct total_notes' do
      expect(info_results[:data][:total_notes]).to eq 3
    end

    it 'returns the correct average note length' do
      expect(info_results[:data][:avg_note_length]).to eq 14
    end
  end
end
