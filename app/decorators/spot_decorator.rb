class SpotDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def self.users
    User.pluck(:name, :id)
  end

  def self.topics
    Topic.pluck(:label, :id)
  end
end
