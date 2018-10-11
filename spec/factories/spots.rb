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

FactoryBot.define do
  factory :spot do
    title       { Faker::Lorem.sentence }
    latitude    { format('%.6g', format('%.6f', Faker::Address.latitude)) }
    longitude   { format('%.6g', format('%.6f', Faker::Address.longitude)) }
    radius      { format('%.1g', format('%.1f', Faker::Number.between(200, 2000))) }
    user
    topic
  end
end
