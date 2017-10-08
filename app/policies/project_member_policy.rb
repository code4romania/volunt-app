class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :membership

  def initialize(user, membership)
    @user = user
    @membership = membership
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
    !profile.volunteer?
  end

  def new?
    create?
  end

  def update?
    !profile.volunteer?
  end

  def edit?
    update?
  end

  def destroy?
    !profile.volunteer?
  end
  
  private
  def profile
    user.profile
  end


end