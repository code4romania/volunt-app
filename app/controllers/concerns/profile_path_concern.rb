module ProfilePathConcern
  extend ActiveSupport::Concern

  def detect_profile_path(profile)
    return coordinator_path(profile) if profile.is_coordinator?
    return fellow_path(profile) if profile.is_fellow?
    return volunteer_path(profile) if profile.is_volunteer?
    return applicant_path(profile) if profile.is_applicant?
  end

end
