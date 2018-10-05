# == Schema Information
#
# Table name: spots
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  latitude   :decimal(, )      not null
#  longitude  :decimal(, )      not null
#  radius     :decimal(, )      not null
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
  belongs_to :user
  belongs_to :topic

  validates :title, :latitude, :longitude, :radius, presence: true
  validates :radius, numericality: { greater_than: 0 }
end
