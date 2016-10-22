module LoginConcern
  extend ActiveSupport::Concern

  def login_user(user)
    session[:user_id] = user.id
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

  module ClassMethods
    def authorization_required(opts={})
      before_filter :check_user_authorization, opts
    end
  end
  
end
