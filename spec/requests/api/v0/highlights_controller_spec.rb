# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V0::HighlightsController, type: :request do
  let(:user_uuid) { '55783d49-7562-4576-a626-3b877557a21f' }
  let(:scope_id) { 'ccf8e44e-05e5-4272-bd0a-aca50171b50f' }
  let(:source_id) { SecureRandom.uuid }
  let(:scope_1_id) { SecureRandom.uuid }
  let(:uuid1) { SecureRandom.uuid }

  before { allow(Rails.application.config).to receive(:consider_all_requests_local) { false } }

  describe 'GET /highlights' do
    let!(:highlight1) { create(:highlight, user_uuid: user_uuid, source_id: source_id, scope_id: scope_1_id) }
    let!(:highlight2) { create(:highlight, user_uuid: user_uuid,                       scope_id: scope_1_id) }
    let!(:highlight3) { create(:highlight, user_uuid: user_uuid,                       scope_id: scope_1_id) }
    let!(:highlight4) { create(:highlight, user_uuid: user_uuid, source_id: source_id, scope_id: scope_1_id, prev_highlight: highlight1) }
    let!(:highlight5) { create(:highlight, user_uuid: user_uuid, source_id: source_id, scope_id: scope_1_id, prev_highlight: highlight1, next_highlight: highlight4) }
    let!(:highlight6) { create(:highlight, user_uuid: user_uuid, source_id: source_id, scope_id: SecureRandom.uuid) }
    let!(:highlight7) { create(:highlight) }

    let(:scope_id) { highlight1.scope_id }
    let(:query_params) do
      {
        source_type: 'openstax_page',
        scope_id: scope_id,
        color: '#000000',
      }
    end

    let(:highlights) { json_response[:data] }

    context 'when the user is not logged in' do
      context 'when the highlight does exist' do
        it('does not allow getting highlights') do
          get highlights_path, params: query_params
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when the user is logged in' do
      before do
        stub_current_user_uuid(user_uuid)
      end

      context 'when just one source id is passed in' do
        it('gets the user\'s highlights for that one source') do
          get highlights_path, params: query_params.merge(source_ids: [highlight2.source_id])
          expect(response).to have_http_status(:ok)
          expect(highlights[0][:id]).to eq highlight2.id
        end
      end

      context 'when multiple source IDs and scope provided' do
        it('gets the user\'s highlights in the order of the source IDs and then by order within page') do
          get highlights_path, params: query_params.merge(
            source_ids: [highlight3, highlight2, highlight1].map(&:source_id),
            scope_id: scope_1_id
          )
          expect(response).to have_http_status(:ok)
          expect(highlights.map{|hl| hl[:id]}).to eq(
            [highlight3, highlight2, highlight1, highlight5, highlight4].map(&:id)
          )
        end
      end

      context 'when only the scope is provided' do
        it 'returns all the user\'s highlights in that scope' do
          get highlights_path, params: query_params.merge(scope_id: scope_1_id)
          expect(highlights.map{|hl| hl[:id]}).to contain_exactly(
            *[highlight1, highlight2, highlight3, highlight4, highlight5].map(&:id)
          )
        end
      end
    end
  end

  describe 'POST /highlights' do
    let(:valid_attributes) do
      {
        highlight: valid_inner_attributes
      }
    end

    let(:valid_inner_attributes) do
      {
        source_id: source_id,
        anchor: 'foo anchor',
        highlighted_content: 'foo content',
        scope_id: scope_id,
        source_type: 'openstax_page',
        color: '#000000',
        location_strategies: [type: 'TextPositionSelector',
                              start: 12,
                              end: 10]
      }
    end

    context 'user unknown' do
      it 'gets a 401 and does not make a highlight' do
        expect do
          post highlights_path, params: valid_attributes
        end.not_to change { Highlight.count }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'user known' do
      before(:each) { stub_current_user_uuid(user_uuid) }

      context 'when the request is valid' do
        before do
          post highlights_path, params: valid_attributes
          @hl1_id = json_response[:id]
        end

        context 'when there are no highlights yet' do
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

        context 'when there is one highlight' do
          # Lots more invalid data tests in the model spec
          it '422s when the new highlight does not specify prev or next' do
            post highlights_path, params: valid_attributes
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.body).to match(/Must specify previous or next highlight/)
          end

          it 'puts the new highlight after the first one when set a prev highlight' do
            valid_inner_attributes.merge!(prev_highlight_id: @hl1_id)
            post highlights_path, params: valid_attributes
            expect(response).to have_http_status(:created)
            expect(json_response[:order_in_source]).to be > 0
          end

          it 'puts the new highlight before the first one when set a next highlight' do
            valid_inner_attributes.merge!(next_highlight_id: @hl1_id)
            post highlights_path, params: valid_attributes
            expect(response).to have_http_status(:created)
            expect(json_response[:order_in_source]).to be < 0
          end
        end
      end

      context 'when the request contains a valid id' do
        let(:target_id) { 'bfb9a31a-6a18-448d-8ecc-2474962d94da' }

        it 'adds a highlight with passed in id' do
          expect do
            new_attributes = valid_attributes.clone
            new_attributes[:highlight][:id] = target_id
            post highlights_path, params: new_attributes
          end.to change { Highlight.count }.by(1)

          expect(response).to have_http_status(201)
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
          expect do
            delete highlights_path(id: highlight.id)
          end.not_to change { Highlight.count }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when a logged-in user owns the highlight' do
      before { stub_current_user_uuid(highlight.user_uuid) }

      it 'is deleted' do
        expect do
          delete highlights_path(id: highlight.id)
        end.to change { Highlight.count }.by(-1)

        expect(response).to have_http_status :ok
      end

      context 'when the highlight does not exist' do
        it '404s' do
          delete highlights_path(id: SecureRandom.uuid)
          expect(response).to have_http_status :not_found
        end
      end

      context 'when there are two highlights' do
        let!(:other) do
          create(:highlight, user_uuid: highlight.user_uuid, source_id: highlight.source_id,
                 scope_id: highlight.scope_id, prev_highlight: highlight)
        end

        it 'sets the first highlight\'s next pointer to nil when the second highlight is deleted' do
          highlight.reload
          expect(highlight.next_highlight_id).not_to be_nil

          expect {
            delete highlights_path(id: other.id)
          }.to change { Highlight.count }.by(-1)

          expect(response).to have_http_status(:ok)
          highlight.reload
          expect(highlight.next_highlight_id).to be_nil
        end
      end
    end

    context 'when a logged-in user does not own the highlight' do
      before { stub_current_user_uuid(SecureRandom.uuid) }

      it 'does not allow deletion' do
        expect do
          delete highlights_path(id: highlight.id)
        end.not_to change { Highlight.count }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PUT /highlights/{id}' do
    let!(:highlight) { FactoryBot.create(:highlight) }

    context 'when the user is not logged in' do
      context 'when the highlight does not exist' do
        it 'gives a 401 before a 404' do
          put highlights_path(id: SecureRandom.uuid)
          expect(response).to have_http_status :unauthorized
        end
      end

      context 'when the highlight does exist' do
        it 'does not allow update' do
          put highlights_path(id: highlight.id), params: { highlight: { color: "#ffffff" } }
          expect(highlight.reload.color).to eq "#000000"
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context 'when a logged-in user owns the highlight' do
      before { stub_current_user_uuid(highlight.user_uuid) }

      it 'can update color' do
        put highlights_path(id: highlight.id), params: { highlight: { color: "#ffffff" } }
        expect(highlight.reload.color).to eq "#ffffff"
        expect(response).to have_http_status :ok
      end

      it 'can update annotation' do
        put highlights_path(id: highlight.id), params: { highlight: { annotation: "oh yeah" } }
        expect(highlight.reload.annotation).to eq "oh yeah"
        expect(response).to have_http_status :ok
      end

      context 'when the highlight does not exist' do
        it '404s' do
          put highlights_path(id: SecureRandom.uuid)
          expect(response).to have_http_status :not_found
        end
      end
    end

    context 'when a logged-in user does not own the highlight' do
      before { stub_current_user_uuid(SecureRandom.uuid) }

      it 'does not allow update' do
        put highlights_path(id: highlight.id), params: { highlight: { color: "#ffffff" } }
        expect(highlight.reload.color).to eq "#000000"
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  def highlights_path(id: nil)
    "/api/v0/highlights#{id.nil? ? '' : "/#{id}"}"
  end
end
