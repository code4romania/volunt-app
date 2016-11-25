require 'yaml'

Rails.configuration.x.documents = YAML.load(File.read(Rails.root.join('config', 'documents.yml')))

