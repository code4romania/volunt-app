class OpeningPolicy < ApplicationPolicy
  attr_reader :user, :opening

  def initialize(user, opening)
    @user = user
    @opening = opening
  end

  def index?
    true
  end

  def show?
    true
  end

  def search?
    index?
  end

  def create?
    not_volunteer
  end

  def new?
    create?
  end

  def update?
    not_volunteer
  end

  def edit?
    update?
  end

  def destroy?
    not_volunteer
  end
  
  private
  def profile
    user.profile
  end

  def not_volunteer
    profile.admin? || profile.hr? || profile.coordinator?
  end


end