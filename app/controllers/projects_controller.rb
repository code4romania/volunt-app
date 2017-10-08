class ProjectsController < ApplicationController
  include LoginConcern
  include SearchConcern

  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  def index
    authorize Project
    @project_search_presenter = ProjectSearchPresenter.new
    @projects = Project.all.includes(:owner).paginate(page: params[:page])
  end

  # GET /projects/1
  def show
    @volunteers = @project.members.volunteers.includes(:profile).paginate(page: params[:volunteers_page])
    openings = is_coordinator? ? @project.openings : @project.openings.visible
    @openings = openings.paginate(page: params[:openings_page])
    if is_coordinator?
      render 'show'
    else
      render 'community_show'
    end
  end

  # POST /projects/search
  def search
    authorize Project
    @project_search_presenter = ProjectSearchPresenter.new search_params
    if @project_search_presenter.blank?
      redirect_to projects_path
      return
    end

    projects = Project
    projects = chain_where_like(projects, 'name', @project_search_presenter.name)

    @projects = projects
    render 'projects/search'
  end

  # GET /projects/new
  def new
    @project = Project.new
    authorize @project
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    authorize @project

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
      authorize @project
    end

    def search_params
      params.fetch(:project_search_presenter, {}).permit(
        :name)
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
