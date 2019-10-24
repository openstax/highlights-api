require 'rails_helper'

RSpec.describe HighlightsController, type: :request do
  # let!(:highlights) { create_list(:highlight, 10) }

  describe 'POST /highlights' do
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

    context 'when the request is valid' do
      before { post '/highlights', params: valid_attributes }

      it 'creates a highlight' do
        expect(json_response['user_uuid']).to eq('user_uuid')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    # context 'when the request is invalid' do
    #   before { post '/todos', params: { title: 'Foobar' } }
    #
    #   it 'returns status code 422' do
    #     expect(response).to have_http_status(422)
    #   end
    #
    #   it 'returns a validation failure message' do
    #     expect(response.body)
    #       .to match(/Validation failed: Created by can't be blank/)
    #   end
    # end
  end
end
