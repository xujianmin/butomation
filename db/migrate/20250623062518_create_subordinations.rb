class CreateSubordinations < ActiveRecord::Migration[8.0]
  def change
    create_table :subordinations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :virtual_user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :subordinations, [ :user_id, :virtual_user_id ], unique: true
  end
end
