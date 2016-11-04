class CoordinatorsController < ApplicationController
  include ProfilesControllerConcern

  profile_controller :coordinator, 'Coordonator'
  
end

