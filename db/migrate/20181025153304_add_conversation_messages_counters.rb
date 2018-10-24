class AddConversationMessagesCounters < ActiveRecord::Migration[5.2]
  def change
    add_column :conversations, :first_user_unread_messages, :integer, default: 0
    add_column :conversations, :second_user_unread_messages, :integer, default: 0
  end
end
