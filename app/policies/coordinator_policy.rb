class CoordinatorPolicy < ApplicationPolicy
  attr_reader :user, :coordinator

  def initialize(user, coordinator)
    @user = user
    @coordinator = coordinator
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