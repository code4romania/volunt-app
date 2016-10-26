class ApplicantsController < ApplicationController
  include ProfilesControllerConcern
  include LoginConcern
  authorization_required

  profile_controller :applicant, 'Aplicant'
  
end

