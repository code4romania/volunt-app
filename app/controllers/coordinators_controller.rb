class CoordinatorsController < ApplicationController
  include ProfilesControllerConcern
  include ProfileDefaultAuthorization

  profile_controller :coordinator, 'Coordonator'
end

