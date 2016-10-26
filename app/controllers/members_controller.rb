class MembersController < ApplicationController
  include LoginConcern
  authorization_required
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /members
  def index
    @members = ProjectMember.all.paginate(page: params[:page])
  end

  # GET /members/1
  def show
  end


  def new_volunteer
    @member = ProjectMember.new(project: @project)
    @profiles = Profile.volunteers
    @member_type = Profile::PROFILE_FLAG_VOLUNTEER
    render 'new'
  end

  def new_fellow
    @member = ProjectMember.new(project: @project)
    @profiles = Profile.fellows
    @member_type = Profile::PROFILE_FLAG_FELLOW
    render 'new'
  end

  # GET /members/1/edit
  def edit
    @profiles = [@member.profile]
  end

  # POST /members
  def create
    @member = ProjectMember.new(member_params)
    @member.project = @project
    if @member.save
      redirect_to back_path, notice: 'Member was successfully added to project.'
    else
      puts @member.errors.inspect
      @member_type = params.fetch(:member_type, Profile::PROFILE_FLAG_VOLUNTEER)
      @profiles = Profile::PROFILE_FLAG_FELLOW.to_s == @member_type.to_s ? Profile.fellows : Profile.volunteers
      render :new
    end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
      redirect_to project_member_path(@project, @member), notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /members/1
  def destroy
    @member.destroy
    redirect_to back_path, notice: 'Member was successfully removed from project.'
  end

  # back_path returns to the calling project or profile
  helper_method :back_path
  def back_path
    return project_path(@project)
  end

  helper_method :form_action_path
  def form_action_path
    @member.new_record? ? project_members_path(@project) :  project_member_path(@project, @member)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = ProjectMember.find(params[:id])
    end
    
    def set_project
      @project = Project.find(params['project_id'])
    end

    # Only allow a trusted parameter "white list" through.
    def member_params
      params.require(:project_member).permit(:profile_id, :role, :status)
    end
end
