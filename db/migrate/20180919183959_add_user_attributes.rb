class AddUserAttributes < ActiveRecord::Migration[5.2]
  def change
    t.integer :gender
  end
end
