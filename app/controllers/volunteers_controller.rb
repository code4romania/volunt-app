class VolunteersController < ApplicationController
  include ProfilesControllerConcern

  profile_controller :volunteer, 'Voluntar'
  
end
