class StatusReportsController < ApplicationController
  include LoginConcern
  authorization_required
  before_action :set_status_report, only: [:show, :edit, :update, :destroy]
  before_action :set_profile_or_project, only: [:new, :create, :index]

  # GET /status_reports
  def index
    if not @project.nil?
      @status_reports = @project.status_reports
    elsif not @profile.nil?
      @status_reports = @profile.status_reports
    else
      @status_reports = StatusReport.all
    end
    @status_reports = @status_reports.paginate(page: params[:page])
  end

  # GET /status_reports/1
  def show
  end

  # GET /projects/1/status_reports/new
  # GET /fellows/1/status_reports/new
  def new
    @status_report = StatusReport.new(report_date: Date.today)
    @status_report.profile = @profile unless @profile.nil?
    @status_report.project = @project unless @project.nil? 
  end

  # GET /status_reports/1/edit
  def edit
  end

  # POST /projects/1/status_reports
  # POST /fellows/1/status_reports
  def create
    @status_report = StatusReport.new(status_report_params)
    @status_report.profile = @profile unless @profile.nil?
    @status_report.project = @project unless @project.nil? 

    if @status_report.save
      redirect_to back_path, notice: 'Status report was successfully created.'
    else
      puts @status_report.errors.inspect
      render :new
    end
  end

  # PATCH/PUT /status_reports/1
  def update
    if @status_report.update(status_report_params)
      redirect_to @status_report, notice: 'Status report was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /status_reports/1
  def destroy
    @status_report.destroy
    redirect_to back_path, notice: 'Status report was successfully destroyed.'
  end

  helper_method :back_path, :form_submit_path
  def back_path
    return fellow_path(@profile) unless @profile.nil?
    return project_path(@project) unless @project.nil?
    return status_reports_path
  end

  def form_submit_path
    return status_report_path(@status_report) unless @status_report.new_record?
    return fellow_status_reports_path(@profile) unless @profile.nil?
    return project_status_reports_path(@project) unless @project.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_status_report
      @status_report = StatusReport.find(params[:id])
      @project = @status_report.project
      @profile = @status_report.profile
    end

    def set_profile_or_project
      @project = Project.find(params[:project_id]) if params.has_key? :project_id
      @profile = Profile.fellows.find(params[:fellow_id]) if params.has_key? :fellow_id
    end

    # Only allow a trusted parameter "white list" through.
    def status_report_params
      params.fetch(:status_report, {}).permit(
          :profile_id,
          :project_id,
          :summary,
          :details,
          :report_date,
          :tags_string,
          :status
        )
    end
end
