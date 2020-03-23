require 'rails_helper'

RSpec.describe 'api v0 info requests', type: :request, api: :v0 do
  let(:user_id) { '7307bc10-6923-4687-81df-2db0c3e6b595' }

  describe '#info' do
    context 'user permitted' do
      it 'returns info' do
        api_get '/info'
        expect(response).to have_http_status(:ok)

        json = json_response
        expect(json).to have_key(:postgres_version)
      end
    end

    context 'user not permitted' do
      before do
        allow(Utilities).to receive(:production_deployment?).and_return(true)
        allow(Rails.application.secrets).to receive(:admin_uuids).and_return(admin_uuids)
      end

      context 'admin_uuids not set' do
        let(:admin_uuids) { nil }

        it 'returns info' do
          api_get '/info'
          expect(response).to have_http_status(:ok)

          json = json_response
          expect(json).not_to have_key(:data)
          expect(json).to have_key(:git_sha)
        end
      end

      context 'admin_uuids set' do
        let(:admin_uuids) { "#{user_id}, b6200d06-4313-4bf3-b9b3-79720498fa94" }

        it 'allows authorized user' do
          stub_current_user_uuid(user_id)
          api_get '/info'
          expect(response).to have_http_status(:ok)

          json = json_response
          expect(json).to have_key(:data)
        end

        it 'disallows unauthorized user' do
          stub_current_user_uuid('foobar')
          api_get '/info'
          expect(response).to have_http_status(:ok)

          json = json_response
          expect(json).not_to have_key(:data)
        end
      end
    end
  end
end
