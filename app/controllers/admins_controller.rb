class AdminsController < ApplicationController
  include ProfilesControllerConcern
  include ProfileDefaultAuthorization

  profile_controller :admin, 'Admin'
  
end

