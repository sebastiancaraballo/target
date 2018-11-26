class AddTimestampsToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :created_at, :datetime, null: false
    add_column :topics, :updated_at, :datetime, null: false
  end
end
