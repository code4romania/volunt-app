class ApplicantsController < ApplicationController
  include ProfilesControllerConcern
  include ProfileDefaultAuthorization

  profile_controller :applicant, 'Aplicant'
  
end

