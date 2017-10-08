class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
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
    profile.admin?
  end

  def new?
    create?
  end

  def update?
    profile.admin? || (profile.coordinator? && profile == project.owner)
  end

  def edit?
    update?
  end

  def destroy?
    profile.admin?
  end
  
  private
  def profile
    user.profile
  end


end