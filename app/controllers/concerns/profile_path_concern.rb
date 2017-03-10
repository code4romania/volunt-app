module ProfilePathConcern
  extend ActiveSupport::Concern

  def detect_profile_path(profile)
    return coordinator_path(profile) if profile.is_coordinator?
    return volunteer_path(profile) if profile.is_volunteer?
    return applicant_path(profile) if profile.is_applicant?
  end
  
  def detect_profile_url(profile)
    return coordinator_url(profile) if profile.is_coordinator?
    return volunteer_url(profile) if profile.is_volunteer?
    return applicant_url(profile) if profile.is_applicant?
  end
end
