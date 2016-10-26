class VolunteersController < ApplicationController
  include ProfilesControllerConcern
  include LoginConcern
  authorization_required

  profile_controller :volunteer, 'Voluntar'
  
end
