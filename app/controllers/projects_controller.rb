class ProjectsController < ApplicationController
  include LoginConcern
  authorization_required LoginConcern::USER_LEVEL_FELLOW,
    except: [:index]
  authorization_required LoginConcern::USER_LEVEL_COMMUNITY,
    only: [:index]

  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    @projects = Project.all.includes(:owner).paginate(page: params[:page])
  end

  # GET /projects/1
  def show
    @status_reports = @project.status_reports.paginate(page: params[:status_reports_page])
    @volunteers = @project.members.volunteers.includes(:profile).paginate(page: params[:volunteers_page])
    @fellows = @project.members.fellows.includes(:profile).paginate(page: params[:fellows_page])
    @openings = @project.openings.paginate(page: params[:openings_page])
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      permitted = [
          :name,
          :beneficiary,
          :description,
          :objective,
          :tags_string,
          :owner_id,
          :urls_string,
          :status,
          :flags]
      Rails.configuration.x.project_urls.each do |k,v|
        permitted << "urls_#{k}".to_sym
      end
      params.require(:project).permit(*permitted)
    end
end
