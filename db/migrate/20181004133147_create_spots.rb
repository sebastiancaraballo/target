class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.string :title, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.decimal :radius, null: false
      t.belongs_to :user, foreign_key: true
      t.belongs_to :topic, foreign_key: true

      t.timestamps
    end
  end
end
