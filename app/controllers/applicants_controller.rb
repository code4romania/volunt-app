class ApplicantsController < ApplicationController
  include ProfilesControllerConcern

  profile_controller :applicant, 'Aplicant'
  
end

