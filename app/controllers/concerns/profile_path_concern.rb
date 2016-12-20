module ProfilePathConcern
  extend ActiveSupport::Concern

  def detect_profile_path(profile)
    return Rails.application.routes.url_helpers.coordinator_path(profile) if profile.is_coordinator?
    return Rails.application.routes.url_helpers.fellow_path(profile) if profile.is_fellow?
    return Rails.application.routes.url_helpers.volunteer_path(profile) if profile.is_volunteer?
    return Rails.application.routes.url_helpers.applicant_path(profile) if profile.is_applicant?
  end

end
