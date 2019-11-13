# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V0::HighlightsController, type: :request do
  let(:user_uuid) { '55783d49-7562-4576-a626-3b877557a21f' }
  let(:source_parent_id) { 'ccf8e44e-05e5-4272-bd0a-aca50171b50f' }
  let(:source_id) { SecureRandom.uuid }

  before { allow(Rails.application.config).to receive(:consider_all_requests_local) { false } }

  describe 'GET /highlights' do
    let!(:highlight1) { create(:highlight, user_uuid: user_uuid) }
    let!(:highlight2) { create(:highlight, user_uuid: user_uuid) }
    let!(:highlight3) { create(:highlight) }

    let(:page) { 1 }
    let(:per_page) { 10 }
    let(:source_parent_ids) { highlight1.source_parent_ids }
    let(:query_params) do
      {
        source_type: 'openstax_page',
        source_parent_ids: source_parent_ids,
        color: '#000000',
        page: page,
        per_page: per_page,
        order: 'asc'
      }
    end

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

      it 'gets the highlights for the user' do
        get highlights_path, params: query_params
        expect(response).to have_http_status(:ok)

        highlights = json_response[:data]

        expect(highlights.count).to eq 2
        expect(highlights.map { |json| json[:anchor] }.uniq).to eq ['fs-id1170572203905']
      end

      context 'when just one source id is passed in' do
        let(:source_parent_ids) { [source_parent_id] }

        it('gets the highlights that have this known uuid as source') do
          get highlights_path, params: query_params
          expect(response).to have_http_status(:ok)

          highlights = json_response[:data]
          expect(highlights.count).to eq 2
        end
      end

      context 'when paging' do
        context 'for a page that exists' do
          let(:per_page) { 1 }
          let(:page) { 1 }

          it 'gets the highlights for the user for the page' do
            get highlights_path, params: query_params
            expect(response).to have_http_status(:ok)

            highlights = json_response[:data]
            expect(highlights.first[:anchor]).to eq 'fs-id1170572203905'
          end

          it 'gets the correct total count' do
            get highlights_path, params: query_params
            expect(response).to have_http_status(:ok)

            highlights = json_response[:data]
            meta = json_response[:meta]

            expect(meta[:total_count]).to eq 2
            expect(highlights.count).to eq 1
          end
        end

        context 'for a page that doesnt exists' do
          let(:per_page) { 1 }
          let(:page) { 10 }

          it 'gets no highlights' do
            get highlights_path, params: query_params
            expect(response).to have_http_status(:ok)
            highlights = json_response[:data]

            expect(highlights.count).to eq 0
          end
        end

        context 'paging defaults' do
          it 'returns the paging defaults in the meta' do
            get highlights_path, params: query_params.except(:per_page, :page)
            expect(response).to have_http_status(:ok)
            meta = json_response[:meta]

            expect(meta[:per_page]).to eq 15
            expect(meta[:page]).to eq 1
          end
        end
      end
    end
  end

  describe 'POST /highlights' do
    let(:valid_attributes) do
      {
        highlight:
        {
          source_id: source_id,
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
        expect do
          post highlights_path, params: valid_attributes
        end.not_to change { Highlight.count }

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
