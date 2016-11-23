require 'yaml'

Rails.configuration.x.project_urls = YAML.load(File.read(Rails.root.join('config', 'project_urls.yml')))
