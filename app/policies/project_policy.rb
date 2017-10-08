class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :post

  def initialize(user, project)
    @user = user
    @project = project
  end

  def create?
    user.profile.admin?
  end


end