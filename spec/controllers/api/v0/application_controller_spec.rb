require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render json: current_user_uuid
    end
  end

  context '#current_user_uuid' do
    context 'there is an SSO cookie' do
      before(:each) do
        # These values (secrets.yml test) copied from development environment accounts.
        # This cookie was generated from these secrets. These are not used in real deployments.
        allow_any_instance_of(ActionController::TestRequest).to receive(:cookies) {
          {
            'oxa_dev' =>
              "eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..tD56OCg6Un6gzkTy.eQAZrea_ORzHiFvg3rmEjxjmRXlqhXIfOYA55RQP9T" \
              "uum2S7d-KqFQiNEVHvdOAz8Jt1UULezUllc1bJ42j7IiBlakUm8VlOIhS6n0XtobmuQkIV7nd_0_DNTn2uvmLC70Z9pGtgUOFm3q" \
              "XtQa5DczQTuoTQ56-_M9uewyIYtj_B0H0bfjDNvsj92hf54K8o486B97qnvfGIkb7jXRUk3q6Aa_NtNIqbmCR9Tac29H9rn7CAcV" \
              "TG2vzG-kfUwpxrA9A-LlkX4SX1LKzsD3TVQe-05Xv9cQdf8zArdeE_9KJGAdbRlM-DVK3ul2YBTy4z92uxY4cA7vtNsANb1ByNn7" \
              "K5zEa4Mnb1OcxhhrPKTTkyVWtt4-w8GhmZl48kBoeQTWEEXtRlksabKe5RhHu3-i3dXvbWBp6ALXjEkAoKC-BDDjCUt_IOErp_g0" \
              "G1CnD3aRU--lqvm2IJnKq1sncTd8qtFTm91MRPzg94O0-OHk7NohktEz3DtJjKeH0EdW98d_mon8OAf4xJDtXrADE-VxAMPhNzoF" \
              "s6o2k4t3BJpIvUj9AGuAx46vkk7B0TeIAXFy8dhq6n5vvFdYnoih1BM47DnOv5DZtABlvQv5xJTfyN23jb-QDKG-AZ--zjtamtkT" \
              "r_7GASXqbQy2xEw2QA0yQCUS6JhnRRCcrC913CU8uPtjMbzWoxkCZjCyxQkX1fcVddU9e3pmay9LZ4zZolVCOwWUp1TuEgYwSweN" \
              "pR4WiwGiWelMhHSZ3QYKjJpGyIkzCSkn7ZQRLLTe0joU43figYs790TPx4waUfwi5r3AED6OSkfxTBsjgOR9DY6083CpCZ4N7lea" \
              "XhsfepgwjiwzVw5TB4YGRg275AE4lZhdKf1lgS7OSk1S7NeMkv88ZDHnVIVAd0wiR9PZf36Ni48CArfC4btn6DT7cQURQOnQTQyi" \
              "K-WvFfkEMdWX7_Z-GRG9CCnVIT3CBBZnvoIcCaUbVmXRqv0cFJmvfsmGsA.FJxz84tw7BCYCrwYeqLpdQ" \
          }
        }
      end

      it 'reads the SSO cookie for it' do
        get :index
        expect(response.body).to eq '1b2dc73a-a792-462b-9b0f-59bd22bac26d'
      end
    end
  end
end
