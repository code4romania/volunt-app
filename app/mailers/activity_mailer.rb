class ActivityMailer < ApplicationMailer
  include ProfilePathConcern
  add_template_helper(ApplicationHelper)
  helper_method :profile_path

  def daily(date)
    @date = date
    @profiles = Profile.where('date(created_at) = ?', date)
    mail(to: Rails.configuration.x.email.daily_to, subject: "Volunt-App: sumar zilnic pentru #{date.to_s}")
  end

  private
  def profile_path(profile)
    detect_profile_path(profile)
  end
end
