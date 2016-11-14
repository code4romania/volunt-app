class MyStatusReportPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation

  attr_accessor :profile, :status_report
      :projects_status_reports

  def self.get_current
    profile = Profile.for_email(current_user_email)
    raise ActiveRecord::RecordNotFound.new('Profile not found for logged in user', 'Profile') if profile.nil?
    
    status = StatusReport.last_for_profile(profile)
    if status.nil? or status.is_published?
      status = StatsusReport.new(profile: profile)
    end

    project_statuses = []
    profile.lead_projects.each do |project|
      project_status = StatusReport.last_for_project(project)
      if project_status.nil? or project_status.is_published?
        project_status = StatusReport.new(project: project)
      end
      project_statuses << MyStatusReportProjectPresenter.new(
        project: project,
        status_report: project_status)
    end

    MyStatusReport.new(
      profile: profile,
      status_report: status,
      project_status_reports: project_statuses)
  end

  class MyStatusReportProjectPresenter
    include ActiveModel::Model
    include ActiveModel::AttributeMethods
    include ActiveModel::Translation

    attr_accessor :project, :status_report
  end

end
