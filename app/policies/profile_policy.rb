class ProfilePolicy < ApplicationPolicy
  attr_reader :user, :profile

  def initialize(user, profile)
    @user = user
    @profile = profile
  end

  def index?
    false
  end

  def show?
    profile.user_id = user.id
  end

  def search?
    false
  end

  def create?
    false
  end

  def new?
    false
  end

  def update?
    false
  end

  def edit?
    false
  end

  def destroy?
    false
  end

  private
  def profile
    user.profile
  end
end