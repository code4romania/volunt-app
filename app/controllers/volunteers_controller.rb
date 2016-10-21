class VolunteersController < ApplicationController
  def index
    @volunteers = Profile.volunteers.order(:full_name).paginate(page: params[:page])
  end

  def show
    @volunteer = Profile.volunteers.find params[:id]
  end

  def search
  end
end
