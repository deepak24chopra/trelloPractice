class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :list_id, null: false
      t.integer :board_id, null: false
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
