# == Schema Information
#
# Table name: spots
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  latitude   :float            not null
#  longitude  :float            not null
#  radius     :float            not null
#  user_id    :integer
#  topic_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_spots_on_topic_id  (topic_id)
#  index_spots_on_user_id   (user_id)
#

class Spot < ApplicationRecord
  MAX_SPOTS_COUNT = ENV['SPOTS_COUNT_LIMIT'].to_i

  belongs_to :user
  belongs_to :topic

  validates :title, :latitude, :longitude, :radius, presence: true
  validates :radius, numericality: { greater_than: 0 }
  validate  :spots_limit

  private

  def spots_limit
    return unless user.spots.count >= MAX_SPOTS_COUNT
    errors.add(:base, I18n.t('api.errors.spot_limit'))
  end
end
