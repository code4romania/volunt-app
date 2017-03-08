class RedirectController < ApplicationController
  include LoginConcern
  authorization_required USER_LEVEL_NEWUSER, only: [:me]

  # GET /me
  def me
    profile = Profile.for_email(current_user_email)
    if profile.nil?
      redirect_to new_applicant_path
    elsif profile.is_coordinator?
      redirect_to coordinator_path(profile)
    elsif profile.is_fellow?
      redirect_to fellow_path(profile)
    elsif profile.is_volunteer?
      redirect_to volunteer_path(profile)
    elsif profile.is_applicant?
      redirect_to applicant_path(profile)
    else
      redirect_to new_applicant_path
    end
  end
end
