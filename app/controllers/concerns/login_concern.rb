module LoginConcern
  extend ActiveSupport::Concern

  def login_user(user)
    session[:user_id] = {
      id: user.id,
      email: user.email
    }
  end

  def current_user
    ensure_user_is_logged_in
    User.find session[:user_id][:id]
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
    
  def check_user_authorization
    redirect_to login_path unless is_user_logged_in?
  end

  def ensure_user_is_logged_in
    raise LoginConcernException.new 'user is not logged in. Code should check `is_user_logged_in?` first' unless is_user_logged_in?
  end

  included do
    helper_method :current_user_email
  end

  module ClassMethods
    def authorization_required(opts={})
      before_action :check_user_authorization, opts
    end
  end
  
end
