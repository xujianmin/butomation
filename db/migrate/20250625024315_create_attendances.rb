class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lottery, null: false, foreign_key: true
      t.integer :virtual_users_count, default: 0, null: false
      t.datetime :joined_at, null: false
      t.string :status, default: 'active', null: false

      t.timestamps
    end

    add_index :attendances, [ :user_id, :lottery_id ], unique: true
    add_index :attendances, :status
  end
end
