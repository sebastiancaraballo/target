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

  has_many :matches, dependent: :destroy

  validates :title, :latitude, :longitude, :radius, presence: true
  validates :radius, numericality: { greater_than: 0 }
  validate  :spots_limit

  after_create :create_matches

  acts_as_mappable lat_column_name: :latitude,
                   lng_column_name: :longitude

  private

  def spots_limit
    return unless user.spots.count >= MAX_SPOTS_COUNT
    errors.add(:base, t('api.errors.spot_limit'))
  end

  def create_matches
    compatible_spots = Spot.within(radius, origin: [latitude, longitude])
                           .where(topic_id: topic_id)
                           .where.not(user_id: user_id)

    compatible_spots.each do |spot|
      create_match(spot)
    end
  end

  def create_match(spot)
    match = matches.create!(first_user_id: user_id, second_user_id: spot.user_id)
    notify(match)
  end

  def notify(match)
    return unless match.second_user_push_token.any?
    data = {
      name: match.second_user_name,
      avatar: match.second_user.avatar_url,
      match_id: match.id
    }
    NotificationService.new.notify(match.second_user_push_token,
                                   I18n.t('api.notifications.new_match'), data)
  end
end
