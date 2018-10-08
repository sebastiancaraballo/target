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

require 'rails_helper'

describe Spot, type: :model do
  describe 'validations' do
    subject(:spot) { build :spot }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:radius) }
    it { is_expected.to validate_numericality_of(:radius) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:topic) }
  end
end
