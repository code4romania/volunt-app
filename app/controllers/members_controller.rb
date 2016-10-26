class MembersController < ApplicationController
  include LoginConcern
  authorization_required
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /members
  def index
    @members = ProjectMember.all.paginate(page: params[:page])
  end

  # GET /members/1
  def show
  end


  # GET /members/new
  def new
    @project = Project.find(params['project_id']) if params.has_key? 'project_id'
    @profile = Profile.find(params['profile_id']) if params.has_key? 'profile_id'
    @member = ProjectMember.new(profile: @profile, project: @project)
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  def create
    @member = ProjectMember.new(member_params)
    @project = Project.find(params['project_id']) if params.has_key? 'project_id'
    @profile = Profile.find(params['profile_id']) if params.has_key? 'profile_id'
    if @member.save
      redirect_to back_path, notice: 'Member was successfully added.'
    else
      render :new
    end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
      redirect_to member_path(@member), notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /members/1
  def destroy
    @member.destroy
    redirect_to back_path, notice: 'Member was successfully removed.'
  end

  # In this context project_members resource is actually members
  # need helpers to make form_for happy
  helper_method :project_member_path
  def project_member_path(member)
    member_path(member)
  end

  # back_path returns to the calling project or profile
  helper_method :back_path
  def back_path
    return project_path(@project) unless @project.nil?
    return profile_path(@profile) unless @profile.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @project = Project.find(params['project_id']) if params.has_key? 'project_id'
      @profile = Profile.find(params['profile_id']) if params.has_key? 'profile_id'
      @member = ProjectMember.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def member_params
      params.require(:project_member).permit(:profile_id, :project_id, :role, :status)
    end
end
