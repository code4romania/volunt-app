module ApplicationHelper
  include ProfilePathConcern

  def tags_placeholder
    'Remote, Hackaton, On-Site'
  end

  def skills_placeholder
    'Front-End, Java, ReactJS, UI, Adobe Illustrator, JIRA'
  end

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

  def httpsify(url)
    ret = url
    begin
      p =  URI.parse(url)
      if (p.scheme == 'http')
        ret = httpsify_path(url: url)
      end
    rescue Exception => e
    end
    return ret
  end

  def opening_visibility_dates(opening)
    from = to = '?'
    from_style = to_style = 'label label-warning'

    if !opening.publish_date.nil?
      from = opening.publish_date.to_date
      from_style = 'label label-default' if opening.publish_date <= Date.today
    end
  
    if !opening.deadline.nil?
      to = opening.deadline.to_date
      to_style = 'label label-default' if opening.deadline >= Date.today
    end

    capture do
      concat content_tag(:span, from, class: from_style)
      concat glyphicon_tag('minus')
      concat content_tag(:span, to, class: to_style)
    end
  end

  def project_with_link(project)
    capture do
      concat content_tag(:span, project.name, class: 'project-name')
      concat ' '
      concat glyphicon_link_to project_path(project)
    end unless project.nil?
  end
  
  def profile_with_link(profile)
    capture do
      concat content_tag(:span, profile.full_name, class: 'profile-full-name')
      concat ' '
      concat glyphicon_link_to detect_profile_path(profile)
    end unless profile.nil?
  end

  def ensure_http_scheme(url)
    begin
      uri = URI.parse(url)
      if (!uri.scheme)
        url = 'http://' + url
      end
    rescue Exception => ex
      Rails.logger.error("ensure_http_scheme: #{ex.class.name}: #{ex.message}")
    end
    return url
  end


  def sanitize_html_area(html)
    # TODO: actually sanitize the html
    (html || '').html_safe
  end

  def options_for_project_status
    capture do 
      Rails.configuration.x.project_status.each do |(k,v)|
        concat content_tag(:option, v["status"], value: k)
      end
    end
  end

  def project_status_tag(project, tag)
    clazz = "project-status"
    statuses = Rails.configuration.x.project_status
    if !project.nil? and statuses.has_key? project.status
      clazz = "#{clazz} project-status-#{statuses[project.status]["status"].parameterize.underscore}"
    end
    content_tag(tag, class: clazz) do
      yield if block_given?
    end
  end

  def project_status_badge(project)
    return if project.nil?
    statuses = Rails.configuration.x.project_status
    text = 'Unknown'
    bgcolor = 'grey'
    textcolor = 'white'
    if statuses.has_key? project.status
      text = statuses[project.status]["status"]
      bgcolor = statuses[project.status]["bgcolor"]
      textcolor = statuses[project.status]["textcolor"]
    end
    content_tag(:span, text, class: "label", style: "color: #{textcolor}; background-color: #{bgcolor}")
  end

end
