require 'rails_helper'

RSpec.describe PageContent, type: :service do
  let(:book_uuid)    { SecureRandom.uuid }
  let(:page_uuid)    { SecureRandom.uuid }
  let(:book_version) { SecureRandom.random_number }

  subject(:page_content) { described_class.new(book_uuid: book_uuid, book_version: book_version, page_uuid: page_uuid) }

  context 'initializing' do
    it 'sets book and page ids' do
      book_id = "#{book_uuid}@#{book_version}"
      expect(page_content.book_id).to eq book_id
      expect(page_content.page_id).to eq "#{book_id}:#{page_uuid}"
    end
  end

  context 'fetching from archive' do
    before do
      json = '{"content":"<!DOCTYPE html><html><body><p id=\\"first\\"></p><p id=\\"second\\"></p><p id=\\"third\\"></p></body></html>"}'
      allow(page_content).to receive(:archive_fetch).and_return(JSON.parse(json))
      page_content.fetch
    end

    it 'parses page content' do
      expect(page_content.content).not_to be nil
    end

    it 'parses anchors' do
      expect(page_content.anchors).to eq ["first", "second", "third"]
    end
  end
end
