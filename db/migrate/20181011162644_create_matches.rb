class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.belongs_to :first_user, null: false
      t.belongs_to :second_user, null: false
      t.belongs_to :spot, null: false
      t.timestamps
    end
  end
end
