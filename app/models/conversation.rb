# == Schema Information
#
# Table name: conversations
#
#  id                          :integer          not null, primary key
#  match_id                    :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  first_user_unread_messages  :integer          default(0)
#  second_user_unread_messages :integer          default(0)
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

  delegate :first?, to: :match

  def unread_messages_count(user)
    first?(user) ? first_user_unread_messages : second_user_unread_messages
  end

  def last_message
    messages.last
  end

  def reset_unread_messages(user)
    if first?(user)
      update(first_user_unread_messages: 0)
    else
      update(second_user_unread_messages: 0)
    end
  end
end
