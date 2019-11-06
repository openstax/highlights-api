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
        # This cookie was generated using localhost Accounts with dev default 'secrets'
        allow_any_instance_of(ActionController::TestRequest).to receive(:cookies) {
          { 'ox' => 'eEkxbm4zQ1kzaG9oWnFFVCs1amV0ajRxYlBXc0NScDFueTFPU1FqSDRtZ3ZlcWFQbVk2SEx6UGtQY' \
                    'VcvMld5aWhYL05TVDJOV3Zjb2x3ZHlkNUdCck5hdGw0bk0vSW0xTFQwdjRlTE1Vcnk0NmNqQWdEbU' \
                    'V5YmE2dkdWdk9UNk1tc3pEdWFMc3Bob0NvWk5QMXhGNUt6U3A1SmhhOGVsajlnN1l0a1dFZlhFQnd' \
                    'vYk4wd0wyQTljZ3haMnk5S0EwaXA4SkNQRDRpUUhLK1crTXA0clNhcWp1bUhCajdjUExEdEVYSVVS' \
                    'TWsrN2t2ek9XcEVqVURQeXkxZndLNHFSUlNPRVQ5T3kzZ3MwRWNrbmRhOVY4a29DdXlEWkc4L3V5S' \
                    '0JmVi9jTWk1b1NjUmsvNXN1VG80b0UvNU90ZGUxcnJMV0xIay9MZ1FrWkJYZGw0U2UzM093PT0tLW' \
                    'RiNDU3Unc3MTJPZDQxSzlLQVM0aEE9PQ==--3684c383b8b6d2b073f8f31fe3a58a583fed74bf' }
        }
      end

      it 'reads the SSO cookie for it' do
        get :index
        expect(response.body).to eq 'f0cb40a7-d644-41ed-ba93-9fccfad72ffd'
      end
    end
  end
end
