class HrPolicy < ProfilePolicy
  attr_reader :user, :hr

  def initialize(user, hr)
    @user = user
    @hr = hr
  end
end