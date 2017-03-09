require 'ostruct'

Rails.configuration.x.email = OpenStruct.new(Rails.application.config_for(:email))


# This email interceptor is ment to capture all outgoing emails in dev and send them to a safe sandbox address
# It can be used in prod as well, but exercise caution and common sense
#
class VoluntariEmailInterceptor
  def self.delivering_email(message)
    message.from = Rails.configuration.x.email.from unless Rails.configuration.x.email.from.blank?
    message.to = Rails.configuration.x.email.to unless Rails.configuration.x.email.to.blank?
    message.bcc = Rails.configuration.x.email.bcc unless Rails.configuration.x.email.bcc.blank?
  end
end

ActionMailer::Base.register_interceptor(VoluntariEmailInterceptor)

if Rails.env.production?
  ActionMailer::Base.default_url_options = {host: Rails.configuration.x.domains.mail_url_host}
end
