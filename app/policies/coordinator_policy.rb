class CoordinatorPolicy < ProfilePolicy
  attr_reader :user, :coordinator

  def initialize(user, coordinator)
    @user = user
    @coordinator = coordinator
  end

end