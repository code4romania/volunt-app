class AdminPolicy < ApplicationPolicy
  attr_reader :user, :admin

  def initialize(user, admin)
    @user = user
    @admin = admin
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