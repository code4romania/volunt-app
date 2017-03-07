namespace :email do

  desc 'Test email template'
  task :send_template_to_profile, [:template_name, :profile_email] => :environment do |t, args|
    template_name = args[:template_name]
    profile_email = args[:profile_email]
    Rails.logger.info("Will attempt send for template: #{template_name} to #{profile_email}")

    template = Template.where(name: template_name).first!
    profile = Profile.where(email: profile_email).first!

    TemplatesMailer.send_template_to_profile(template, profile).deliver_now
  end

  desc 'Send activity'
  task :send_daily_activity, [:hours] => :environment do |t, args|
    # use 25h not 24 to ensure overlap (no missing gaps)
    hours = (args[:hours] || 25).to_i
    Rails.logger.info(":send_daily_activity #{hours}: #{args.inspect}")
    ActivityMailer.daily(hours.hours.ago, Time.now).deliver_now
  end
  
end
