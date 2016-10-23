# Preview all emails at http://localhost:3000/rails/mailers/templates_mailer
class TemplatesMailerPreview < ActionMailer::Preview
  def send_template_to_profile
    profile = Profile.first
    template = Template.first
    TemplatesMailer.send_template_to_profile(template, profile)
  end
end
