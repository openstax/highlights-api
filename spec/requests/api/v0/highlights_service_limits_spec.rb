# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V0::HighlightsController, type: :request do
  describe 'Highlights Controller service limits' do
    context 'when highlights per source per user are outside limits' do
      it 'raises a ServiceLimitsError exception' do
      end
      it 'resets the num when deleting a highlight' do
      end
    end

    context 'when highlights per user are outside limits' do
      it 'raises a ServiceLimitsError exception' do
      end
      it 'resets the num when deleting a highlight' do
      end
    end

    context 'when chars per note per user are outside limits' do
      it 'raises a ServiceLimitsError exception' do
      end
      it 'resets the num when deleting a note' do
      end
    end

    context 'when chars per note are outside limits' do
      it 'raises a ServiceLimitsError exception' do
      end
    end

    context 'when highlights per GET' do
      it 'raises a ServiceLimitsError exception' do
      end
    end
  end
end
