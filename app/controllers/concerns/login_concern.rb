module LoginConcern
  extend ActiveSupport::Concern

  USER_LEVEL_NEWUSER   =   1
  USER_LEVEL_COMMUNITY =  10
  USER_LEVEL_VOLUNTEER =  20
  USER_LEVEL_FELLOW    = 100

  def login_user(user)
    session_data= {
      id: user.id,
      email: user.email, 
      level: USER_LEVEL_NEWUSER
    }
    profile = Profile.for_email(user.email)
    if profile
      session_data[:profile_id] = profile.id
      if profile.is_fellow? or profile.is_coordinator?
        session_data[:level] = USER_LEVEL_FELLOW
      elsif profile && profile.is_volunteer?
        session_data[:level] = USER_LEVEL_VOLUNTEER
      else
        session_data[:level] = USER_LEVEL_COMMUNITY
      end
    end
    session[:user_id] = session_data
  end

  def current_user
    ensure_user_is_logged_in
    User.find session[:user_id]["id"]
  end

  # Most times only the user display name is needed
  # this gets it from session, avoiding the DB lookup
  def current_user_email
    ensure_user_is_logged_in
    session[:user_id]["email"]
  end

  def current_user_profile
    ensure_user_is_logged_in
    profile = nil
    if session[:user_id].has_key? "profile_id"
      profile = Profile.find session[:user_id]["profile_id"]
    end
    if profile.nil? or !profile.has_email?(current_user_email)
      profile = Profile.for_email current_user_email
    end
    return profile
  end

  def logout_user
    session.delete(:user_id)
  end

  def is_user_logged_in?
    session.key? :user_id
  end

  def current_user_level
    ensure_user_is_logged_in
    return session[:user_id]["level"] || 0
  end

  def is_user_level_authorized?(required_level)
    ensure_user_is_logged_in
    return current_user_level >= required_level
  end

  def is_new_user?
    return current_user_level == USER_LEVEL_NEWUSER
  end

  def is_user_level_volunteer?
    return is_user_level_authorized? USER_LEVEL_VOLUNTEER
  end

  def is_user_level_fellow?
    return is_user_level_authorized? USER_LEVEL_FELLOW
  end

  def ensure_user_is_logged_in
    raise LoginConcernException.new 'user is not logged in. Code should check `is_user_logged_in?` first' unless is_user_logged_in?
  end

  def layout_for_current_user
    return 'new_user' if is_new_user?
    return 'application' if is_user_level_authorized? USER_LEVEL_FELLOW
    return 'volunteer' if is_user_level_authorized? USER_LEVEL_VOLUNTEER
    return 'community'
  end

  included do
    helper_method :current_user_email, :is_new_user?,
        :is_user_level_volunteer?,
        :is_user_level_fellow?

    layout :layout_for_current_user

    rescue_from ActionController::InvalidAuthenticityToken do |ex|
      begin
        Rails.logger.error("CSRF: #{ex.class.name}: #{ex.message} ip:#{request.remote_ip} #{request.method}:#{request.original_url}")
      ensure
        logout_user
        redirect_to root_path, notice: 'CSRF exception. Are cookies disabled?'
      end
    end
  end

  module ClassMethods
    def authorization_required(required_level = USER_LEVEL_FELLOW, opts={})
      before_action opts do
        redirect_to login_path, notice: 'Higher level authorization is required to access requested resource' if !is_user_logged_in? or !is_user_level_authorized?(required_level)
      end
    end
  end
end
