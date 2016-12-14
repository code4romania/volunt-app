module ProfileDefaultAuthorization
  extend ActiveSupport::Concern

  included do
    # 'show' action has special authorization in order to be able to view one own profile
    authorization_required LoginConcern::USER_LEVEL_FELLOW, except: [:new, :create, :show, :edit, :update]
    before_action :authorization_required_or_self, only: [:show, :edit, :update]
    before_action :authorization_required_or_new_user, only: [:new, :create]
  end
end
