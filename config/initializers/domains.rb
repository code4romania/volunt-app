require 'ostruct'

Rails.configuration.x.domains = OpenStruct.new(Rails.application.config_for(:domains))
