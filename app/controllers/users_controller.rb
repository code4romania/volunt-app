class UsersController < ApplicationController
  include LoginConcern

  authorization_required(LoginConcern::USER_LEVEL_NEWUSER)

  # GET
  def change_password
    @presenter = ChangePasswordPresenter.new
  end

  # PUT
  def set_password
    @presenter = ChangePasswordPresenter.new(params.fetch(:change_password_presenter, {}).
      permit(:old_password, :password, :password_confirmation))

    @presenter.user = current_user

    if @presenter.valid?
      @presenter.user.password = @presenter.password

      if @presenter.user.save
        redirect_to me_path, notice: 'Parola a fost actualizată cu succes'
        return
      end
    end

    render action: 'change_password'
  end
end
