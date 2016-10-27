module ApplicationHelper

  def glyphicon_tag(glyph)
    content_tag(:span, "",  class: "glyphicon glyphicon-#{glyph}")
  end

  def glyphicon_submit_helper(glyph)
    button_tag(type: 'submit', class: 'btn btn-primary') do
      glyphicon_tag(glyph)
    end
  end

  def glyphicon_link_to(url, glyph='play-circle')
    link_to url, class: 'btn btn-link btn-glyph' do
      glyphicon_tag(glyph)
    end
  end

  def ensure_http_scheme(url)
    uri = URI.parse(url)
    if (!uri.scheme)
      url = 'http://' + url
    end
    return url
  end

  def detect_profile_path(profile)
    return coordinator_path(profile) if profile.is_coordinator?
    return fellow_path(profile) if profile.is_fellow?
    return volunteer_path(profile) if profile.is_volunteer?
    return applicant_path(profile) if profile.is_applicant?
  end

end
