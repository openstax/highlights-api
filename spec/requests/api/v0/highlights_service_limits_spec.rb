# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V0::HighlightsController', type: :request do
  describe 'Highlights Controller service limits' do
    let(:user) { create(:user) }
    let!(:highlight1) { create(:highlight, user: user) }
    let!(:highlight2) { create(:highlight, user: user) }
    let!(:highlight3) { create(:highlight, user: user) }

    let(:query_params) do
      {
        source_type: 'openstax_page',
        scope_id: 'ccf8e44e-05e5-4272-bd0a-aca50171b50f'
      }
    end

    context 'when the user is logged in' do
      before do
        stub_current_user_uuid(user.id)

        ServiceLimits.send('remove_const', 'MAX_HIGHLIGHTS_PER_GET')
        ServiceLimits.const_set('MAX_HIGHLIGHTS_PER_GET', 2)
      end

      it 'should raise an exception for max highlights per get' do
        expect do
          get highlights_path, params: query_params
        end.to raise_error(ServiceLimits::ExceededMaxHighlightsPerGet)
      end
    end
  end

  def highlights_path(id: nil)
    "/api/v0/highlights#{id.nil? ? '' : "/#{id}"}"
  end
end
