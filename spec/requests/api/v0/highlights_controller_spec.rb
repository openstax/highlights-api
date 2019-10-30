require 'rails_helper'

RSpec.describe Api::V0::HighlightsController, type: :request do
  describe 'POST /highlights' do
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

    context 'when the request is valid' do
      before { post '/api/v0/highlights', params: valid_attributes }

      it 'creates a highlight' do
        expect(json_response['user_uuid']).to eq('user_uuid')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request params are invalid' do
      before { post '/api/v0/highlights', params: { something: 'Foobar' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/param is missing or the value is empty/)
      end
    end
  end
end
