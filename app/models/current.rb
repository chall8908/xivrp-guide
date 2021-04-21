class Current < ActiveSupport::CurrentAttributes
  attribute :user, :ability

  def user=(user)
    super
    self.ability = Ability.new(user)
  end
end
