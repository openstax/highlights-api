class PageContent
  attr_accessor :book_id, :page_id, :content, :doc

  def initialize(book_uuid:, book_version:, page_uuid:)
    @book_id = "#{book_uuid}@#{book_version}"
    @page_id = "#{book_id}:#{page_uuid}"
  end

  def s3
    @s3 ||= OpenStax::Content::S3.new
  end

  def latest_archive_version
    @latest_archive_version ||= s3.ls.last
  end

  def archive
    @archive ||= OpenStax::Content::Archive.new latest_archive_version
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
