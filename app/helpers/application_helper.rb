module ApplicationHelper

  def ensure_http_scheme(url)
    uri = URI.parse(url)
    if (!uri.scheme)
      url = 'http://' + url
    end
    return url
  end

end
