class HrsController < ApplicationController
  include ProfilesControllerConcern
  include ProfileDefaultAuthorization

  profile_controller :hr, 'Human resources'
  
end

