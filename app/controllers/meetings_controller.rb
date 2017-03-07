class MeetingsController < ApplicationController
  include LoginConcern
  authorization_required
  before_action :set_meeting, only: [:show, :destroy]

  # GET /meetings
  def index
    @meetings = Meeting.all.paginate(page: params[:page])
  end

  # GET /meetings/1
  def show
  end

  # GET /meetings/new
  def new
    @meeting_presenter = MeetingPresenter.create_new(current_user_profile)
  end

  # GET /meetings/1/edit
  def edit
    @meeting_presenter = MeetingPresenter.load_meeting(params[:id])
  end

  # POST /meetings
  def create
    @meeting_presenter = MeetingPresenter.create_new
    @meeting_presenter.assign_params(params)

    if @meeting_presenter.save
      redirect_to @meeting_presenter.meeting, notice: 'Meeting was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /meetings/1
  def update
    @meeting_presenter = MeetingPresenter.load_meeting(params[:id])
    @meeting_presenter.assign_params(params)

    if @meeting_presenter.save
      redirect_to @meeting_presenter.meeting, notice: 'Meeting was successfully updated.'
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
end
