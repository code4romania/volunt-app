class TemplatesMailer < ApplicationMailer

  def send_template_to_profile(template, profile, opts={})
    @template = template
    @profile = profile
    @to = profile.email
    mail(to: profile.email, subject: template.subject)
  end

end
