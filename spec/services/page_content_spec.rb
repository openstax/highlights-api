require 'rails_helper'

RSpec.describe PageContent, type: :service do
  let(:book_uuid)          { SecureRandom.uuid }
  let(:page_uuid)          { SecureRandom.uuid }
  let(:book_version)       { SecureRandom.random_number }
  let(:s3_archive_version) { '2' }
  let(:rex_archive_version){ '1' }

  subject(:page_content) { described_class.new(book_uuid: book_uuid, book_version: book_version, page_uuid: page_uuid) }

  before do
    allow(page_content).to receive(:fetch_rex_books).and_return({})
    allow(page_content).to receive(:fetch_rex_archive_version).and_return(rex_archive_version)
  end

  context 'initializing' do
    it 'sets book and page ids' do
      book_id = "#{book_uuid}@#{book_version}"
      expect(page_content.book_id).to eq book_id
      expect(page_content.page_id).to eq "#{book_id}:#{page_uuid}"
    end
  end

  context '#archive_version' do
    it 'uses the overriden archive version if available' do
      allow(page_content).to receive(:overriden_archive_version).and_return('override')
      expect(page_content.archive_version).to eq 'override'
    end

    it 'uses the rex archive version if there is no override' do
      expect(page_content.overriden_archive_version).to eq nil
      expect(page_content.archive_version).to eq rex_archive_version
    end

    it 'falls back to the latest S3 version' do
      allow(page_content).to receive(:latest_archive_version).and_return(s3_archive_version)
      allow(page_content).to receive(:rex_archive_version).and_return(nil)

      expect(page_content.archive_version).to eq s3_archive_version
    end
  end

  context '#overriden_archive_version' do
    context 'when archiveOverride is available' do
      before do
        books = { book_uuid => { 'archiveOverride' => 'override' } }
        allow(page_content).to receive(:fetch_rex_books).and_return(books)
      end

      it 'returns the override version' do
        expect(page_content.overriden_archive_version).to eq 'override'
      end
    end

    context 'when archiveOverride is not available' do
      before do
        books = { book_uuid => {} }
        allow(page_content).to receive(:fetch_rex_books).and_return(books)
      end

      it 'returns nil' do
        expect(page_content.overriden_archive_version).to be nil
      end
    end

    context 'when there is no book match' do
      before do
        allow(page_content).to receive(:fetch_rex_books).and_return({})
      end

      it 'returns nil' do
        expect(page_content.overriden_archive_version).to be nil
      end
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
