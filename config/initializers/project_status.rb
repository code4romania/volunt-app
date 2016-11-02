require 'yaml'

Rails.configuration.x.project_status = YAML::load_file(Rails.root.join('config', 'project_status.yml'))
