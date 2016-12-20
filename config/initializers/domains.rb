require 'ostruct'

Rails.configuration.x.domains = OpenStruct.new(Rails.application.config_for(:domains))

[   Rails.configuration.action_mailer,
    Rails.configuration.action_controller,
    Rails.application.routes].each do |c|
  c.default_url_options = {} if c.default_url_options.nil?
  c.default_url_options.store(:host, Rails.configuration.x.domains.mail_url_host)
end
