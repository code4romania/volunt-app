class ProfilePolicy < ApplicationPolicy
  attr_reader :user, :profile

  def initialize(user, profile)
    @user = user
    @profile = profile
  end

  def index?
    true
  end

  def show?
    profile.user_id = user.id
  end

  def search?
    true
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private
  def profile
    user.profile
  end
end