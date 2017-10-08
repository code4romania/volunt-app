class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery prepend: true
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  rescue_from ::Pundit::NotAuthorizedError do |ex|
    begin
      Rails.logger.error(ex.message)
    ensure
      redirect_back fallback_location: projects_path, notice: 'User does not have permission to do this.'
    end
  end
end
