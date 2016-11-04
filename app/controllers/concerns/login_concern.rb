module LoginConcern
  extend ActiveSupport::Concern

  USER_LEVEL_COMMUNITY = 10
  USER_LEVEL_VOLUNTEER = 20
  USER_LEVEL_FELLOW    = 100

  def login_user(user)
    level = USER_LEVEL_COMMUNITY
    profile = Profile.for_email(user.email)
    if profile
      if profile.is_fellow? or profile.is_coordinator?
        level = USER_LEVEL_FELLOW
      elsif profile && profile.is_volunteer?
        level = USER_LEVEL_VOLUNTEER
      end
    end
    session[:user_id] = {
      id: user.id,
      email: user.email,
      level: level
    }
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

  def logout_user
    session.delete(:user_id)
  end

  def is_user_logged_in?
    session.key? :user_id
  end

  def current_user_level
    ensure_user_is_logged_in
    return session[:user_id]["level"] || USER_LEVEL_COMMUNITY
  end

  def is_user_level_authorized?(required_level)
    ensure_user_is_logged_in
    return current_user_level >= required_level
  end

  def ensure_user_is_logged_in
    raise LoginConcernException.new 'user is not logged in. Code should check `is_user_logged_in?` first' unless is_user_logged_in?
  end

  def layout_for_current_user
    return 'application' if is_user_level_authorized? USER_LEVEL_FELLOW
    return 'volunteer' if is_user_level_authorized? USER_LEVEL_VOLUNTEER
    return 'community'
  end

  included do
    helper_method :current_user_email

    layout :layout_for_current_user
  end

  module ClassMethods
    def authorization_required(required_level = USER_LEVEL_FELLOW, opts={})
      before_action opts do
        redirect_to login_path, notice: 'Higher level authorization is required to access requested resource' if !is_user_logged_in? or !is_user_level_authorized?(required_level)
      end
    end
  end
end
