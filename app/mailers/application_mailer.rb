class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: Rails.configuration.x.email.from
  layout 'mailer'
end
