class OpeningsController < ApplicationController
  include LoginConcern
  authorization_required LoginConcern::USER_LEVEL_FELLOW,
      except: [:index, :show]
  authorization_required LoginConcern::USER_LEVEL_COMMUNITY,
      only: [:index, :show]

  before_action :set_opening, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:new, :create]

  # GET /openings
  def index
    @openings = openings.paginate(page: params[:page])
  end

  # GET /openings/1
  def show
  end

  # GET /openings/new
  def new
    @opening = Opening.new(project: @project)
  end

  # GET /openings/1/edit
  def edit
  end

  # POST /openings
  def create
    @opening = Opening.new(opening_params)
    if @project
      @opening.project =  @project
    end

    if @opening.save
      redirect_to back_path, notice: 'Opening was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /openings/1
  def update
    if @opening.update(opening_params)
      redirect_to @opening, notice: 'Opening was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /openings/1
  def destroy
    @opening.destroy
    redirect_to back_path, notice: 'Opening was successfully destroyed.'
  end

  helper_method :back_path, :form_submit_path
  def back_path
    return project_path(@project) unless @project.nil?
    return openings_path
  end

  def form_submit_path
    return opening_path(@opening) unless @opening.new_record?
    return project_openings_path(@project) unless @project.nil?
    return openings_path
  end

  private
    def openings
      is_coordinator? ? Opening.all : Opening.visible
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_opening
      @opening = openings.find(params[:id])
    end

    def set_project
      # Since set_project is called only on :new, :create 
      # it does not expose projects existance via 404 do non-fellows
      # because the authorization action that runs before
      #
      @project = Project.find(params[:project_id]) if params.has_key? :project_id
    end

    # Only allow a trusted parameter "white list" through.
    def opening_params
      params.require(:opening).permit(:title, :description, :deadline, :publish_date, :tags_string, :skills_string, :experience, :project_id, :contact)
    end
end
