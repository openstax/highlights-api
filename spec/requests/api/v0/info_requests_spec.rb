require 'rails_helper'

RSpec.describe 'api v0 info requests', type: :request, api: :v0 do
  context "#info" do
    it "returns info" do
      api_get 'info'
      expect(response).to have_http_status(:ok)

      json = json_response
      expect(json[:version]).to eq '0.0.0'
    end
  end
end
