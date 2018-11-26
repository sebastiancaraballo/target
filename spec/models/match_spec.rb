# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  first_user_id  :integer          not null
#  second_user_id :integer          not null
#  spot_id        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_matches_on_first_user_id   (first_user_id)
#  index_matches_on_second_user_id  (second_user_id)
#  index_matches_on_spot_id         (spot_id)
#

require 'rails_helper'

describe Match, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:spot) }
    it { is_expected.to belong_to(:first_user).class_name('User') }
    it { is_expected.to belong_to(:second_user).class_name('User') }
    it { is_expected.to have_one(:conversation).dependent(:destroy) }

    context 'when first and second user are the same' do
      let(:user)    { create(:user) }
      let(:match)   { build(:match, first_user_id: user.id, second_user_id: user.id) }

      it 'is not valid' do
        expect(match).to_not be_valid
      end

      it 'returns error message' do
        match.valid?
        expect(match.errors[:base]).to include t('api.errors.not_same_user')
      end
    end
  end

  describe 'callbacks' do
    context 'when two spots match' do
      let(:topic) { create(:topic) }
      let!(:spot) do
        create(:spot,
               latitude: -34.906821,
               longitude: -56.201086,
               radius: 500,
               topic_id: topic.id)
      end

      it 'creates the match' do
        create_notification_mock(200, create_notification_ok_body)
        expect do
          create(:spot,
                 latitude: -34.907603,
                 longitude: -56.201101,
                 radius: 500,
                 topic_id: topic.id)
        end.to change(Match, :count).by(1)
      end
    end
  end
end
