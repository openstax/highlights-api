class PageContent
  attr_accessor :book_id, :page_id, :archive_version, :content, :doc

  def initialize(book_uuid:, book_version:, page_uuid:, archive_version:)
    @book_uuid = book_uuid
    @book_id = "#{book_uuid}@#{book_version}"
    @page_id = "#{book_id}:#{page_uuid}"
    @archive_version = archive_version
  end

  def archive
    @archive ||= OpenStax::Content::Archive.new version: @archive_version
  end

  def fetch_archive_content
    rescue_from_fetch_parse_errors do
      JSON.parse(archive.fetch(page_id))['content']
    end
  end

  def fetch
    @content = fetch_archive_content
    @doc = Nokogiri::HTML(@content)
    self
  end

  def anchors
    @doc.xpath('//@id').map(&:value)
  end

  def rescue_from_fetch_parse_errors(return_obj = nil)
    begin
      yield
    rescue JSON::ParserError,
           Faraday::ConnectionFailed => exception
      if Rails.application.config.consider_all_requests_local
        raise exception
      else
        Raven.capture_exception(exception)
        return return_obj
      end
    end
  end
end
