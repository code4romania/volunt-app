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
end
