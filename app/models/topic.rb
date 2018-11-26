# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Topic < ApplicationRecord
  has_many :spots, dependent: :destroy

  validates :label, presence: true
end
