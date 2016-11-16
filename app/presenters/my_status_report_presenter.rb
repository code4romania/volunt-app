class MyStatusReportPresenter
  include ActiveModel::Model
  include ActiveModel::AttributeMethods
  include ActiveModel::Translation
  include ActiveModel::Validations

  attr_accessor :profile,
        :status_report,
        :project_status_reports

  
  # Make FormBuilder#nested_attributes_association? happy 
  def project_status_reports_attributes=(value)
    raise "should not be called"
  end

  def self.get_current(email)
    profile = Profile.for_email(email)
    raise ActiveRecord::RecordNotFound.new('Profile not found for logged in user', 'Profile') if profile.nil?
    
    date = Date.today + ((1-Date.today.wday) % 7) # Next monday
    status = StatusReport.last_for_profile(profile)
    if status.nil? or status.is_published?
      status = StatusReport.new(profile: profile, report_date: date)
    end

    project_statuses = []
    profile.lead_projects.each do |project|
      project_status = StatusReport.last_for_project(project)
      if project_status.nil? or project_status.is_published?
        project_status = StatusReport.new(project: project, report_date: date)
      end
      project_statuses << MyStatusReportProjectPresenter.new(
        project: project,
        status_report: project_status)
    end

    MyStatusReportPresenter.new(
      profile: profile,
      status_report: status,
      project_status_reports: project_statuses)
  end

  def self.from_params(values)
      # {
      #   "status_report"=>{
      #         "id"=>"", "profile_id" =>"...", "report_date"=>"2016-11-21", "summary"=>"...", "details"=>"...", "tags_string"=>"..."}, 
      #   "project_status_reports_attributes"=>{
      #         "0"=>{
      #             "status_report"=>{"id"=>"", "project_id" => "...", "summary"=>"...", "details"=>"...", "tags_string"=>"..."}
      #         }, 
      #         "1"=>{
      #             "status_report"=>{"id"=>"", "project_id" => "...", "summary"=>"...", "details"=>"...", "tags_string"=>"..."}
      #         }
      #    }
      # }
    profile_params = values.require(:status_report).permit(:report_date, :summary, :details, :tags_string, :id, :profile_id)
    
    profile = Profile.find profile_params[:profile_id]
    status = StatusReport.where(id: profile_params[:id]).first_or_initialize(profile: profile)
    status.assign_attributes(profile_params.except(:id, :profile_id))

    project_statuses = []
    
    values.require(:project_status_reports_attributes).each do |k,v|
      project_params = v.require(:status_report).permit(:summary, :details, :tags_string, :id, :project_id)
      project = Project.find project_params[:project_id]
      project_status = StatusReport.where(id: project_params[:id]).first_or_initialize(project: project)
      project_status.assign_attributes(project_params.except(:id, :project_id))
      project_status.report_date = status.report_date
      project_statuses << MyStatusReportProjectPresenter.new(
        project: project,
        status_report: project_status)
    end
    
    MyStatusReportPresenter.new(
      profile: profile,
      status_report: status,
      project_status_reports: project_statuses)
  end

  def save
    ret = false
    StatusReport.transaction do
      if !self.status_report.save
        raise ActiveRecord::Rollback
      end
      self.project_status_reports.each do |ps|
        if !ps.status_report.save
          raise ActiveRecord::Rollback
        end
      end
      ret = true
    end
    return ret
  end

  def add_project
    self.project_status_reports << MyStatusReportProjectPresenter.new
  end

  class MyStatusReportProjectPresenter
    include ActiveModel::Model
    include ActiveModel::AttributeMethods
    include ActiveModel::Translation

    attr_accessor :project, :status_report
  end

end
