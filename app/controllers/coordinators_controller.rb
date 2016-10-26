class CoordinatorsController < ApplicationController
  include ProfilesControllerConcern
  include LoginConcern
  authorization_required

  profile_controller :coordinator, 'Coordonator'
  
end

