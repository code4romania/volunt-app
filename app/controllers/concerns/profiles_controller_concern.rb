module ProfilesControllerConcern
  extend ActiveSupport::Concern
  include SearchConcern
  
  included do
    before_action :set_profile, only: [:show, :edit, :update, :destroy]
  end

  def new
    @profile = Profile.new
    profile_set_flag(@profile)
    render 'profiles/new'
  end
  
  def edit
    render 'profiles/edit'
  end

  def create
    @profile = Profile.new(profile_params)
    profile_set_flag(@profile)
    if @profile.save
      redirect_to profile_path(@profile), notice: "#{profile_resource_name} was succesfully created"
    else
      render 'profiles/new'
    end
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path(@profile), notice: "#{profile_resource_name} was succesfully updated"
    else
      render 'profiles/edit'
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_path, notice: "#{profile_resource_name} was succesfully deleted"
  end

  def index
    @profile_search_presenter = ProfileSearchPresenter.new
    @profiles = profiles_scope.order(:full_name).paginate(page: params[:page])
    render 'profiles/index'
  end

  def show
    @memberships = @profile.memberships.includes(:project).paginate(page: params[:memberships_page])
    if @profile.has_email?(current_user_email)
      @status_reports = @profile.status_reports.paginate(page: params[:status_reports_page])
      render 'profiles/me'
    else
      render  'profiles/show'
    end
  end
  
  def search
    @profile_search_presenter = ProfileSearchPresenter.new search_params
    if @profile_search_presenter.blank?
      redirect_to profiles_path
      return
    end
    
    profiles = profiles_scope
    profiles = chain_where_like(profiles, 'full_name', @profile_search_presenter.full_name);
    profiles = chain_where_like(profiles, 'email', @profile_search_presenter.email);
    profiles = chain_where_like(profiles, 'location', @profile_search_presenter.location);

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

      profiles = profiles.where(sql, *opts)
    end

    @profiles = profiles.order(:full_name)
    render 'profiles/search'
  end


  private

  def search_params
    params.fetch(:profile_search_presenter, {}).permit(
      :full_name, :email, :location, :attrs)
  end

  def set_profile
    @profile = profiles_scope.find params[:id]
  end

  def profile_params
    params.fetch(:profile, {}).permit(
      :full_name,
      :nick_name,
      :photo,
      :tags_string,
      :skills_string,
      :contacts_string,
      :location,
      :title,
      :workplace,
      :email,
      :description,
      :urls_string)
  end

  module ClassMethods

    def profile_controller(controller, resource_name)
      controller_path = "#{controller}_path"
      controller_edit_path = "edit_#{controller}_path"
      controller_new_path = "new_#{controller}_path"
      controllers_search_path = "search_#{controller}s_path"
      controllers_path = "#{controller}s_path"
      controller_scope = "#{controller}s"
      profile_flag = "Profile::PROFILE_FLAG_#{controller.upcase}".constantize
      
      # Define the route helpers as aliases of the current type
      helper_method :profile_path,
        :profiles_path,
        :edit_profile_path,
        :new_profile_path,
        :search_profiles_path
      
      define_method 'profile_path' do |profile|
        send(controller_path, profile)
      end
      
      define_method 'profiles_path' do
        send(controllers_path)
      end

      define_method 'new_profile_path' do
        send(controller_new_path)
      end

      define_method 'edit_profile_path' do |profile|
        send(controller_edit_path, profile)
      end

      define_method 'search_profiles_path' do
        send(controllers_search_path)
      end

      helper_method :profile_resource_name
      define_method 'profile_resource_name' do
        resource_name
      end

      define_method 'profiles_scope' do
        Profile.send(controller_scope)
      end

      define_method 'profile_set_flag' do |profile|
        profile.flags = profile_flag
      end

    end
    
  end

end
