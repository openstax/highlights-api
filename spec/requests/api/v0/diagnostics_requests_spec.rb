require 'rails_helper'

RSpec.describe 'api v0 diagnostics requests', type: :request, api: :v0 do
  context '#exception' do
    before do
      allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
    end

    it 'yields a 500' do
      api_get 'diagnostics/exception'
      expect(response).to have_http_status(:internal_server_error)
    end
  end

  context '#status_code' do
    it 'responds with the provided status code' do
      api_get 'diagnostics/status_code/502'
      expect(response).to have_http_status(502)
    end
  end
end
