class PageContent

  ALLOWED_REQUEST_HOSTS = [
    /^openstax\.org$/,
    /^.*\.openstax\.org$/,
    /^rex-web-[^\.]*\.herokuapp\.com$/
  ]

  attr_accessor :book_id, :page_id, :request_host, :content, :doc

  def initialize(book_uuid:, book_version:, page_uuid:, request_host:)
    @book_uuid = book_uuid
    @book_id = "#{book_uuid}@#{book_version}"
    @page_id = "#{book_id}:#{page_uuid}"
    @request_host = request_host
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

  def rex_host
    host = Rails.application.secrets.rex_host
    host = host == 'dynamic' ? get_request_host : host
    Raven.extra_context rex_host: host
    host
  end

  def get_request_host
    uri = Addressable::URI.heuristic_parse request_host

    if ALLOWED_REQUEST_HOSTS.none? {|hostable| hostable.match? uri.host }
      raise InvalidRexHostError
    end

    uri.scheme = 'https'
    uri.to_s
  end

  def rex_release_url
    "#{rex_host}/rex/release.json"
  end

  def rex_config_url
    "#{rex_host}/rex/config.json"
  end

  def fetch_rex_archive_version
    rescue_from_fetch_parse_errors do
      body = Faraday.get(rex_config_url).body
      JSON.parse(body)['REACT_APP_ARCHIVE']
    end
  end

  def fetch_rex_books
    rescue_from_fetch_parse_errors({}) do
      body = Faraday.get(rex_release_url).body
      JSON.parse(body)['books']
    end
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
           InvalidRexHostError,
           Faraday::ConnectionFailed,
           Addressable::URI::InvalidURIError => exception
      if Rails.application.config.consider_all_requests_local
        raise exception
      else
        Raven.capture_exception(exception)
        return return_obj
      end
    end
  end
end

class InvalidRexHostError < StandardError
end
