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

class Match < ApplicationRecord
  belongs_to :spot
  belongs_to :first_user, class_name: 'User'
  belongs_to :second_user, class_name: 'User'

  validate :not_same_user

  private

  def not_same_user
    return unless first_user_id == second_user_id
    errors.add(:base, t('api.errors.not_same_user'))
  end
end
