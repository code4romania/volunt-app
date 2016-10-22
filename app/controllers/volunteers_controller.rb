class VolunteersController < ApplicationController
  include LoginConcern
  authorization_required

  def index
    @profile_search_presenter = ProfileSearchPresenter.new
    @volunteers = Profile.volunteers.order(:full_name).paginate(page: params[:page])
  end

  def show
    @volunteer = Profile.volunteers.find params[:id]
  end

  def search
    @profile_search_presenter = ProfileSearchPresenter.new search_params
    if @profile_search_presenter.blank?
      redirect_to volunteers_path
    else
      volunteers = Profile.volunteers
      unless @profile_search_presenter.full_name.blank?
        volunteers = volunteers.where('full_name LIKE ?', "%#{@profile_search_presenter.full_name}%")
      end
      unless @profile_search_presenter.email.blank?
        volunteers = volunteers.where('email LIKE ?', "%#{@profile_search_presenter.email}%")
      end
      unless @profile_search_presenter.location.blank?
        volunteers = volunteers.where('location LIKE ?', "%#{@profile_search_presenter.location}%")
      end
      unless @profile_search_presenter.skills.blank?
        skills = @profile_search_presenter.skills.split(/\,|;/).map do |x|
          x.strip.upcase
        end
        volunteers = volunteers.where('skills @> ARRAY[?]::varchar[]', skills)
      end
      @volunteers = volunteers.order(:full_name)
    end
  end

  private

  def search_params
    params.fetch(:profile_search_presenter, {}).permit(
      :full_name, :email, :location, :skills)
  end
end
