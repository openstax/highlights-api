require 'rails_helper'

RSpec.describe PageContent, type: :service do
  let(:book_uuid)        { SecureRandom.uuid }
  let(:page_uuid)        { SecureRandom.uuid }
  let(:book_version)     { SecureRandom.random_number }
  let(:archive_version)  { '123.456' }
  subject(:page_content) {
    described_class.new(
      book_uuid: book_uuid,
      book_version: book_version,
      page_uuid: page_uuid,
      archive_version: archive_version
    )
  }

  context 'initializing' do
    it 'sets book and page ids' do
      book_id = "#{book_uuid}@#{book_version}"
      expect(page_content.book_id).to eq book_id
      expect(page_content.page_id).to eq "#{book_id}:#{page_uuid}"
    end
  end

  context 'fetching from archive' do
    context 'when there are no issues' do
      before do
        html = '<!DOCTYPE html><html><body><p id="first"></p><p id="second"></p><p id="third"></p></body></html>'
        allow(page_content).to receive(:fetch_archive_content).and_return(html)
        page_content.fetch
      end

      it 'parses page content' do
        expect(page_content.content).not_to be nil
      end

      it 'parses anchors' do
        expect(page_content.anchors).to eq ["first", "second", "third"]
      end
    end

    context 'when the content 404s' do
      before do
        allow_any_instance_of(OpenStax::Content::Archive).to receive(:fetch).and_return('will not parse')
      end

      it 'handles parser errors' do
        expect { page_content.fetch }.to raise_error(JSON::ParserError) # Should raise errors in dev

        allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
        expect { page_content.fetch }.not_to raise_error
        expect(page_content.anchors).to eq []
      end
    end
  end
end
