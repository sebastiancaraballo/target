# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  conversation_id :integer
#  sender_id       :integer          not null
#  content         :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_sender_id        (sender_id)
#

class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :sender, class_name: :User

  validates :content, presence: true

  after_create_commit :broadcast_message
  after_create_commit :increment_unread_messages_counter
  after_create_commit :notify_addressee

  private

  def notify_addressee
    return unless addressee_push_token.any?
    NotificationService.new.notify(addressee_push_token,
                                   I18n.t('api.notifications.new_message'), message_data)
  end

  def message_data
    {
      sender: sender.name,
      avatar: sender.avatar_url,
      content: content
    }
  end

  def addressee_push_token
    conversation.other_user(sender).push_token
  end

  def increment_unread_messages_counter
    if conversation.first?(sender)
      conversation.increment!(:second_user_unread_messages)
    else
      conversation.increment!(:first_user_unread_messages)
    end
  end

  def broadcast_message
    ConversationChannel.broadcast_to(conversation, render_content(content))
  end

  def render_content(content)
    {
      content: content
    }
  end
end
