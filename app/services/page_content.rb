class PageContent
  attr_accessor :book_id, :page_id, :content, :doc

  def initialize(book_uuid:, book_version:, page_uuid:)
    @book_uuid = book_uuid
    @book_id = "#{book_uuid}@#{book_version}"
    @page_id = "#{book_id}:#{page_uuid}"
  end

  def s3
    @s3 ||= OpenStax::Content::S3.new
  end

  def latest_archive_version
    @latest_archive_version ||= s3.ls.last
  end

  def overriden_archive_version
    @overriden_archive_version ||= fetch_rex_books.dig(@book_uuid, 'archiveOverride').to_s.gsub('/apps/archive/', '').presence
  end

  def archive_version
    overriden_archive_version || Rails.application.secrets.content[:archive_version] || latest_archive_version
  end

  def archive
    @archive ||= OpenStax::Content::Archive.new archive_version
  end

  def fetch_rex_books
    url = Rails.application.secrets.content[:rex_release_url]

    begin
      body = Faraday.get(url).body
      JSON.parse(body)['books']
    rescue JSON::ParserError, Faraday::ConnectionFailed => exception
      if Rails.application.config.consider_all_requests_local
        raise exception
      else
        Raven.capture_exception(exception)
        return {}
      end
    end
  end

  def fetch_archive_content
    begin
      JSON.parse(archive.fetch(page_id))["content"]
    rescue JSON::ParserError, Faraday::ConnectionFailed => exception
      if Rails.application.config.consider_all_requests_local
        raise exception
      else
        Raven.capture_exception(exception)
        return nil
      end
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
end
