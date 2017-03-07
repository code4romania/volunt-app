namespace :import do
  desc "Import contacts from slack, provide json FILE or slack TOKEN"
  task slack: :environment do
    require 'slack_import'

    service = if ENV['FILE']
                SlackImport.from_file(ENV['FILE'])
              elsif ENV['TOKEN']
                SlackImport.from_slack(ENV['TOKEN'])
              else
                raise "Please provide FILE or TOKEN"
              end

    p service.stats
  end
end
