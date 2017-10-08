class VolunteerPolicy < ProfilePolicy
  attr_reader :user, :volunteer

  def initialize(user, volunteer)
    @user = user
    @volunteer = volunteer
  end

  def create?
    profile.admin? || profile.hr?
  end

  def update?
    profile.admin? || profile.hr?
  end
end