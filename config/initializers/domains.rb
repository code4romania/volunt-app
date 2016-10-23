require 'ostruct'

Rails.configuration.x.domains = OpenStruct.new(Rails.application.config_for(:domains))

Rails.configuration.action_mailer.default_url_options = {} if Rails.configuration.action_mailer.default_url_options.nil?
Rails.configuration.action_mailer.default_url_options.store(:host, Rails.configuration.x.domains.mail_url_host)
