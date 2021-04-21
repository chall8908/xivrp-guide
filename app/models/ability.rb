class Ability
  include CanCan::Ability
  include CanCanCan::Masquerade

  def initialize(user)
    can :read, Event

    return unless user.present?

    # Users can create, update, and destroy their own events
    can [:create, :update, :destroy], Event, user_id: user.id
  end
end
