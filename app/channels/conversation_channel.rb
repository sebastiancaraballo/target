class ConversationChannel < ApplicationCable::Channel
  def subscribed
    reject unless conversation
    stream_for conversation
  end

  def speak(data)
    message = data['message']
    if message.blank?
      validate_message
    else
      Message.create(conversation_id: data['conversation_id'],
                     sender: current_user,
                     content: message)
    end
  end

  private

  def conversation
    current_user.conversations.find_by(id: params[:conversation_id])
  end

  def validate_message
    connection.transmit identifier: params, error: t('api.errors.blank_message')
  end
end
