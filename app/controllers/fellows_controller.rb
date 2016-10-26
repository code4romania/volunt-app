class FellowsController < ApplicationController
  include ProfilesControllerConcern
  include LoginConcern
  authorization_required

  profile_controller :fellow, 'Bursier'
  
end

