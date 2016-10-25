class VolunteersController < ApplicationController
  include LoginConcern
  include SearchConcern
  authorization_required
  before_action :set_volunteer, only: [:show, :edit, :update, :destroy]

  def new
    @volunteer = Profile.new(flags: Profile::PROFILE_FLAG_VOLUNTEER)
  end
  
  def edit
  end

  def create
    @volunteer = Profile.new(volunteer_params)
    @volunteer.is_volunteer = true
    if @volunteer.save
      redirect_to volunteer_path(@volunteer), notice: 'Volunteer was succsfully created'
    else
      render :new
    end
  end

  def update
    if @volunteer.update(volunteer_params)
      redirect_to volunteer_path(@volunteer), notice: 'Volunteer was succesfully updated'
    else
      render :edit
    end
  end

  def destroy
    @volunteer.destroy
    redirect_to volunteers_path, notice: 'Volunteer was succesfully deleted'
  end

  def index
    @profile_search_presenter = ProfileSearchPresenter.new
    @volunteers = Profile.volunteers.order(:full_name).paginate(page: params[:page])
  end

  def show
  end

  def search
    @profile_search_presenter = ProfileSearchPresenter.new search_params
    if @profile_search_presenter.blank?
      redirect_to volunteers_path
      return
    end
    
    volunteers = Profile.volunteers
    volunteers = chain_where_like(volunteers, 'full_name', @profile_search_presenter.full_name);
    volunteers = chain_where_like(volunteers, 'email', @profile_search_presenter.email);
    volunteers = chain_where_like(volunteers, 'location', @profile_search_presenter.location);

    unless @profile_search_presenter.attrs.blank?
      # attrs is a mixed value: tags, skills and title
      # two of them are arrays, one is string. Enjoy
      
      # transform attrs into tags (split, upercase, no spaces)
      tags = @profile_search_presenter.attrs.split(/\,|;/).map {|x| x.strip.upcase}

      # positive vs. negative
      pos_tags, neg_tags = split_tags_pos_neg(tags)

      tags_sql, tags_opts = define_where_fragment_array_pos_neg("tags", pos_tags, neg_tags)
      skills_sql, skills_opts = define_where_fragment_array_pos_neg("skills", pos_tags, neg_tags)     
      # for title we not consider negative tags as it would qualify everything
      title_sql, title_opts = define_where_fragment_like_pos_neg('title', pos_tags, [])

      sql = "(#{tags_sql}) OR (#{skills_sql})"
      opts = tags_opts.concat(skills_opts)
      unless title_opts.blank?
        sql += " OR (#{title_sql})"
        opts = opts.concat(title_opts)
      end

      puts sql
      puts opts.inspect

      volunteers = volunteers.where(sql, *opts)
    end

    @volunteers = volunteers.order(:full_name)
  end

  # In this context 'profiles' means 'volunteers'
  # need helper methods or the form_for gets confused
  #
  helper_method :profile_path, :profiles_path
  def profile_path(profile)
    volunteer_path(profile)
  end

  def profiles_path
    volunteers_path
  end

  private

  def search_params
    params.fetch(:profile_search_presenter, {}).permit(
      :full_name, :email, :location, :attrs)
  end

  def set_volunteer
    @volunteer = Profile.volunteers.find params[:id]
  end

  def volunteer_params
    params.fetch(:profile, {}).permit(
      :full_name,
      :nick_name,
      :photo,
      :tags_string,
      :skills_string,
      :location,
      :title,
      :workplace,
      :email,
      :description,
      :urls_string)
  end

end
