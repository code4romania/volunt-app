class VolunteerPolicy < ProfilePolicy
  attr_reader :user, :volunteer

  def initialize(user, volunteer)
    @user = user
    @volunteer = volunteer
  end

  def index?
    true
  end

  def search?
    true
  end

  def show?
    binding.remote_pry
    volunteer.user_id == user.id || !profile.volunteer?
  end

  def create?
     !profile.coordinator?
  end

  def update?
    profile.admin? || profile.hr? || user.id == volunteer.user_id
  end

  def destroy?
    profile.admin? || profile.hr?
  end
end