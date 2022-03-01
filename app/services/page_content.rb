class PageContent
  attr_accessor :book_id, :page_id, :content, :doc

  def initialize(book_uuid:, book_version:, page_uuid:)
    @book_uuid = book_uuid
    @book_id = "#{book_uuid}@#{book_version}"
    @page_id = "#{book_id}:#{page_uuid}"
  end

  def overriden_archive_version
    @overriden_archive_version ||= fetch_rex_books.dig(
      @book_uuid, 'archiveOverride'
    ).to_s.delete_prefix('/apps/archive/').presence
  end

  def rex_archive_version
    @rex_archive_version ||= fetch_rex_archive_version
  end

  def archive_version
    overriden_archive_version || rex_archive_version
  end

  def archive
    @archive ||= OpenStax::Content::Archive.new archive_version
  end

  def fetch_rex_archive_version
    url = Rails.application.secrets.rex[:config_url]

    rescue_from_fetch_parse_errors do
      body = Faraday.get(url).body
      JSON.parse(body)['REACT_APP_ARCHIVE']
    end
  end

  def fetch_rex_books
    url = Rails.application.secrets.rex[:release_url]

    rescue_from_fetch_parse_errors({}) do
      body = Faraday.get(url).body
      JSON.parse(body)['books']
    end
  end

  def fetch_archive_content
    rescue_from_fetch_parse_errors do
      JSON.parse(archive.fetch(page_id))["content"]
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
    rescue JSON::ParserError, Faraday::ConnectionFailed => exception
      if Rails.application.config.consider_all_requests_local
        raise exception
      else
        Raven.capture_exception(exception)
        return return_obj
      end
    end
  end
end
