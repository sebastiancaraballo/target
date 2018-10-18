# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  match_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_conversations_on_match_id  (match_id)
#

class Conversation < ApplicationRecord
  belongs_to :match

  has_many :user_conversations
  has_many :users, through: :user_conversations
  has_many :messages, dependent: :destroy
end
