class CreateBoardPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :board_permissions do |t|
      t.integer :user_id, null: false
      t.integer :board_id, null: false
      t.integer :permission, null: false

      t.timestamps
    end
  end
end
