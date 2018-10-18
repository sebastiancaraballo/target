class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.belongs_to :match, foreign_key: true

      t.timestamps
    end
    create_table :user_conversations do |t|
      t.belongs_to :user, index: true
      t.belongs_to :conversation, index: true

      t.timestamps
    end

    create_table :messages do |t|
      t.belongs_to :conversation, foreign_key: true
      t.belongs_to :sender, null: false
      t.string :content, null: false
      t.timestamps
    end
  end
end
