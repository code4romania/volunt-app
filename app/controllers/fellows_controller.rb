class FellowsController < ApplicationController
  include ProfilesControllerConcern

  profile_controller :fellow, 'Bursier'

end

