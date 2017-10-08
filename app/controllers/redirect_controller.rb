class RedirectController < ApplicationController
  include LoginConcern
  authorization_required USER_LEVEL_NEWUSER, only: [:me]

  # GET /me
  def me
    profile = Profile.for_email(current_user_email)

    if profile.nil?
      redirect_to volunteer_path(profile)
    elsif profile.coordinator?
      redirect_to coordinator_path(profile)
    elsif profile.volunteer?
      redirect_to volunteer_path(profile)
    elsif profile.admin?
      redirect_to admin_path(profile)
    elsif profile.hr?
      redirect_to hr_path(profile)
    end
  end
end
