class ActivityMailer < ApplicationMailer
  include ProfilePathConcern
  add_template_helper(ApplicationHelper)
  helper_method :profile_path

  def daily(from_time, to_time)
    @from_time = from_time
    @to_time = to_time
    @profiles = Profile.where('created_at between :from_time and :to_time', from_time: from_time, to_time: to_time)
    mail(to: Rails.configuration.x.email.daily_to, subject: "Volunt-App: sumar zilnic pentru #{from_time}-#{to_time}")
  end

  private
  def profile_path(profile)
    detect_profile_path(profile)
  end
end
