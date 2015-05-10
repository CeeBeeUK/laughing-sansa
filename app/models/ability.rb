class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      # can :read, :all
      can :read, Event
      can :join, Event
      can :sign_up, Event
      can [:read, :update], [User, EventPlayerScore]
    end
  end
end
