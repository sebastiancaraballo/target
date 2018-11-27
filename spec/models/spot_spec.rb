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
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:topic) }

    context 'when exceeding 10th spot creation limit' do
      let(:user)    { create(:user) }
      let!(:spots)  { create_list(:spot, 10, user_id: user.id) }
      let(:spot)    { build(:spot, user_id: user.id) }

      it 'is not valid' do
        expect(spot).to_not be_valid
      end

      it 'returns error message' do
        spot.valid?
        expect(spot.errors[:base]).to include t('api.errors.spot_limit')
      end
    end
  end
end
