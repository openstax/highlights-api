require 'rails_helper'

RSpec.describe PageContent, type: :service do
  let(:book_uuid)           { SecureRandom.uuid }
  let(:page_uuid)           { SecureRandom.uuid }
  let(:book_version)        { SecureRandom.random_number }
  let(:rex_archive_version) { '1' }
  subject(:page_content) {
    described_class.new(book_uuid: book_uuid, book_version: book_version, page_uuid: page_uuid, request_host: 'dev.openstax.org')
  }

  before do
    allow(page_content).to receive(:fetch_rex_books).and_return({})
    allow(page_content).to receive(:fetch_rex_archive_version).and_return(rex_archive_version)
    allow(Rails.application.secrets).to receive(:rex_host).and_return('dynamic')
  end

  context 'initializing' do
    it 'sets book and page ids' do
      book_id = "#{book_uuid}@#{book_version}"
      expect(page_content.book_id).to eq book_id
      expect(page_content.page_id).to eq "#{book_id}:#{page_uuid}"
    end
  end

  context '#rex_host' do
    it 'uses the request host if rex_host is not set' do
      expect(page_content.rex_host).to match(page_content.request_host)
    end

    it 'uses rex_host if set' do
      host = 'https://configured.host'
      allow(Rails.application.secrets).to receive(:rex_host).and_return(host)

      expect(page_content.rex_host).to match(host)
    end
  end

  context '#get_request_host' do
    it 'can parse a host without protocol' do
      page_content.request_host = 'dev.openstax.org'
      expect(page_content.get_request_host).to eq('https://dev.openstax.org')
    end

    it 'upgrades request_host to https' do
      page_content.request_host = 'http://dev.openstax.org'
      expect(page_content.get_request_host).to eq('https://dev.openstax.org')
    end

    it 'limits request_host to allowed hosts' do
      ['invalid.openstax.com', 'rex-webb-issue-123.herokuapp.com', ''].each do |invalid|
        page_content.request_host = invalid
        expect { page_content.get_request_host }.to raise_error(InvalidRexHostError)
      end

      ['openstax.org',
       'dev.openstax.org',
       'release-123.sandbox.openstax.org',
       'rex-web-issue-123-abc.herokuapp.com'].each do |valid|
        page_content.request_host = valid
        expect(page_content.get_request_host).to eq "https://#{valid}"
      end
    end
  end

  context '#rex_release_url' do
    it 'returns the correct url' do
      page_content.request_host = 'dev.openstax.org'
      expect(page_content.rex_release_url).to eq 'https://dev.openstax.org/rex/release.json'
    end
  end

  context '#rex_config_url' do
    it 'returns the correct url' do
      page_content.request_host = 'dev.openstax.org'
      expect(page_content.rex_config_url).to eq 'https://dev.openstax.org/rex/config.json'
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

  context 'fetching rex archive version' do
    before do
      allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
      allow(page_content).to receive(:fetch_rex_archive_version).and_call_original
    end
    context 'when there are no issues' do
      it 'returns the version' do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
          double("response", status: 200, body: '{"REACT_APP_ARCHIVE": 123}')
        )
        expect(page_content.fetch_rex_archive_version).to eq 123
      end
    end

    context 'when the fetch fails' do
      it 'handles the error and returns nil' do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
          double("response", status: 404, body: '')
        )
        expect(page_content.fetch_rex_archive_version).to eq nil
      end
    end
  end

  context 'fetching rex books' do
    before do
      allow(Rails.application.config).to receive(:consider_all_requests_local) { false }
      allow(page_content).to receive(:fetch_rex_books).and_call_original
    end
    context 'when there are no issues' do
      it 'returns the list of books' do
        books = '{"books": {"abc": {"defaultVersion": "def"}}}'
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
          double("response", status: 200, body: books)
        )
        expect(page_content.fetch_rex_books.deep_symbolize_keys).to eq({ abc: { defaultVersion: "def" } })
      end
    end

    context 'when the fetch fails' do
      it 'handles the error and returns nil' do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
          double("response", status: 404, body: '')
        )
        expect(page_content.fetch_rex_books).to eq({})
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
