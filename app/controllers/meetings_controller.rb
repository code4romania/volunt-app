class MeetingsController < ApplicationController
  include LoginConcern
  authorization_required
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  # GET /meetings
  def index
    @meetings = Meeting.all.paginate(page: params[:page])
  end

  # GET /meetings/1
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
    @meeting.profiles << current_user_profile
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  def create
    @meeting = Meeting.new
    assign_params(@meeting)
    if (params.has_key? 'add_fellow')
      @meeting.profiles.new
      render :new
      return
    end

    if @meeting.save
      redirect_to @meeting, notice: 'Meeting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /meetings/1
  def update
    assign_params(@meeting)
    if (params.has_key? 'add_fellow')
      @meeting.profiles.new
      render :new
      return
    end
    if @meeting.save
      redirect_to @meeting, notice: 'Meeting was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /meetings/1
  def destroy
    @meeting.destroy
    redirect_to meetings_url, notice: 'Meeting was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def assign_params(meeting)
      p = meeting_params
      meeting.assign_attributes p.except(:profiles_attributes)
      profile_ids = p[:profiles_attributes].inject([]) do |h,a|
        h << a[1][:id] unless a[1][:id].blank?
        h
      end
      if profile_ids != meeting.profile_ids
        meeting.updated_at_will_change!
        meeting.singleton_class.before_save do
          Rails.logger.debug("before save: ids: #{meeting.profile_ids.inspect} => #{profile_ids.inspect}")
          meeting.profile_ids = profile_ids
        end
      end

#      deleted_ids = []
#      p[:profiles_attributes].each do |k,v|
#        next if v[:profile_id].blank? and v[:id].blank?
#        if v[:id].blank?
#          deleted_ids << v[:profile_id]
#          meeting.updated_at_will_change!
#        elsif v[:profile_id].blank?
#          profile = Profile.fellows.find(v[:id])
#          meeting.profiles << profile unless meeting.profiles.include? profile
#        end
#      end
#      meeting.singleton_class.after_save do
#        Rails.logger.debug("before save: #{deleted_ids.inspect}")
#        deleted_ids.each do |id|
#          meeting.profiles.delete(id)
#        end
#      end
    end

    # Only allow a trusted parameter "white list" through.
    def meeting_params
      params.fetch(:meeting, {}).permit :date,
        :agency,
        :location,
        :attendees_string,
        :summary,
        :notes,
        :attn_coordinators,
        :tags_string,
        profiles_attributes: [:id, :profile_id]
    end
end
