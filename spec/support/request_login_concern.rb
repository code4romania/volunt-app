module RequestLoginConcern
  extend ActiveSupport::Concern

  included do
    fixtures :users, :profiles
  end

  def login(user_sym)
    user = users(user_sym)
    Rails.logger.debug "login: #{user.inspect}"
    post login_path, {params: {
      'HTTPS': 'on',
      login_presenter: {email: user.email, password: 'password'}}}
    expect(response).to redirect_to(root_path)
  end

end
