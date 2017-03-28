require_relative 'boot'

require 'rails/all'
require 'dotenv'
Dotenv.load

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Voluntari
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/app/presenters)
  end
end

Raven.configure do |config|
  config.dsn = 'https://ad2ba2f5f5264b5cbd1fc373e367f1e8:1df2cbb8424d4443ac1506b5ea745e71@logs.code4.ro/4'
  config.environments = ['staging', 'production']
end
