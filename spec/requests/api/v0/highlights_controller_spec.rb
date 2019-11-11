require 'rails_helper'

RSpec.describe Api::V0::HighlightsController, type: :request do
  let(:user_uuid) { '55783d49-7562-4576-a626-3b877557a21f' }

  before { allow(Rails.application.config).to receive(:consider_all_requests_local) { false } }

  describe 'POST /highlights' do
    let(:valid_attributes) do
      {
        highlight:
        {
          source_id: 'foo id',
          anchor: 'foo anchor',
          highlighted_content: 'foo content',
          source_type: 'openstax_page',
          color: '#000000',
          location_strategies: [type: 'TextPositionSelector',
                                start: 12,
                                end: 10]
        }
      }
    end

    context 'user unknown' do
      it 'gets a 401 and does not make a highlight' do
        expect{
          post highlights_path, params: valid_attributes
        }.not_to change{Highlight.count}

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'user known' do
      before(:each) { stub_current_user_uuid(user_uuid) }

      context 'when the request is valid' do
        before { post highlights_path, params: valid_attributes }

        it 'creates a highlight' do
          expect(json_response[:anchor]).to eq('foo anchor')
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'is owned by the right user' do
          expect(Highlight.first.user_uuid).to eq user_uuid
        end
      end

      context 'when the request contains a valid id' do
        let(:target_id) { 'bfb9a31a-6a18-448d-8ecc-2474962d94da' }

        before do
          new_attributes = valid_attributes.clone
          new_attributes[:highlight][:id] = target_id
          post highlights_path, params: new_attributes
        end

        it 'adds a highlight with passed in id' do
          expect(response).to have_http_status(201)
          expect(Highlight.count).to eq 1
          expect(Highlight.first.id).to eq target_id
        end
      end

      context 'when the request params are invalid' do
        context 'bogus params' do
          before { post highlights_path, params: { something: 'Foobar' } }

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a validation failure message' do
            expect(response.body)
              .to match(/param is missing or the value is empty/)
          end
        end

        context 'when the location_strategies are invalid' do
          before do
            new_attributes = valid_attributes.clone
            new_attributes[:highlight][:location_strategies] = [type: 'Foobar']
            post highlights_path, params: new_attributes
          end

          it 'returns status code 422' do
            expect(response).to have_http_status(422)
          end

          it 'returns a validation failure message' do
            expect(response.body)
              .to match(/invalid strategy detected/)
          end
        end
      end
    end
  end

  describe 'DELETE /highlights/{id}' do
    let!(:highlight) { FactoryBot.create(:highlight) }

    context 'when the user is not logged in' do
      context 'when the highlight does not exist' do
        it 'gives a 401 before a 404' do
          delete highlights_path(id: SecureRandom.uuid)
          expect(response).to have_http_status :unauthorized
        end
      end

      context 'when the highlight does exist' do
        it 'does not allow deletion' do
          expect{
            delete highlights_path(id: highlight.id)
          }.not_to change{Highlight.count}

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when a logged-in user owns the highlight' do
      before { stub_current_user_uuid(highlight.user_uuid) }

      it 'is deleted' do
        expect{
          delete highlights_path(id: highlight.id)
        }.to change{Highlight.count}.by(-1)

        expect(response).to have_http_status :ok
      end

      context 'when the highlight does not exist' do
        it '404s' do
          delete highlights_path(id: SecureRandom.uuid)
          expect(response).to have_http_status :not_found
        end
      end
    end

    context 'when a logged-in user does not own the highlight' do
      before { stub_current_user_uuid(SecureRandom.uuid) }

      it 'does not allow deletion' do
        expect{
          delete highlights_path(id: highlight.id)
        }.not_to change{Highlight.count}

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  def highlights_path(id: nil)
    "/api/v0/highlights#{id.nil? ? '' : "/#{id}"}"
  end
end
