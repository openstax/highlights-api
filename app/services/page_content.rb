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

  def archive_fetch
    archive.json(page_id)
  end

  def fetch
    @content = archive_fetch["content"]
    @doc = Nokogiri::HTML(@content)
  end

  def anchors
    @doc.xpath('//@id').map(&:value)
  end

end
