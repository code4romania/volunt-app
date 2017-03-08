class FellowsController < ApplicationController
  include ProfilesControllerConcern

  profile_controller :fellow, 'Bursier'

  # 'show' action has special authorization in order to be able to view one own profile
  authorization_required LoginConcern::USER_LEVEL_FELLOW, except: [:index, :new, :create, :show, :edit, :update]
  authorization_required LoginConcern::USER_LEVEL_COMMUNITY, only: [:index]
  before_action :authorization_required_or_self, only: [:show, :edit, :update]
  before_action :authorization_required_or_new_user, only: [:new, :create]
end

