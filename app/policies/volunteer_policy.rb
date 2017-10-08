class VolunteerPolicy < ApplicationPolicy
  attr_reader :user, :volunteer

  def initialize(user, volunteer)
    @user = user
    @volunteer = volunteer
  end

  def index?
    false
  end

  def show?
    false
  end

  def search?
    false
  end
end