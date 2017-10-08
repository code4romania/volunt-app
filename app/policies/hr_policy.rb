class HrPolicy < ApplicationPolicy
  attr_reader :user, :hr

  def initialize(user, hr)
    @user = user
    @hr = hr
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