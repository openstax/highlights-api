require 'rails_helper'

RSpec.describe PageContent, type: :service do
  let(:book_uuid)       { SecureRandom.uuid }
  let(:page_uuid)       { SecureRandom.uuid }
  let(:book_version)    { SecureRandom.random_number }
  let(:archive_version) { '123.456' }

  subject(:page_content) { described_class.new(book_uuid: book_uuid, book_version: book_version, page_uuid: page_uuid) }

  before do
    allow(page_content).to receive(:fetch_rex_books).and_return({})
  end

  context 'initializing' do
    it 'sets book and page ids' do
      book_id = "#{book_uuid}@#{book_version}"
      expect(page_content.book_id).to eq book_id
      expect(page_content.page_id).to eq "#{book_id}:#{page_uuid}"
    end
  end

  context '#archive_version' do
     before do
      content = { archive_version: archive_version }
      allow(Rails.application.secrets).to receive(:content).and_return(content)
     end

    it 'uses the overriden archive version if available' do
      books = { book_uuid => { 'defaultVersion' => '1.0', 'archiveOverride' => 'override' } }
      allow(page_content).to receive(:fetch_rex_books).and_return(books)
      expect(page_content.archive_version).to eq 'override'
    end

    it 'uses the configured archive version' do
      expect(page_content.archive_version).to eq archive_version
    end

    it 'falls back to the latest S3 version' do
      latest_version = 's3version'
      allow(page_content).to receive(:latest_archive_version).and_return(latest_version)
      allow(Rails.application.secrets).to receive(:content).and_return({})

      expect(page_content.archive_version).to eq latest_version
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
        allow(page_content).to receive(:latest_archive_version).and_return(nil)
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
