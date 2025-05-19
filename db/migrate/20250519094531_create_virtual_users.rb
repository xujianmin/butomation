class CreateVirtualUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :virtual_users do |t|
      t.string :last_name
      t.string :first_name
      t.string :gender
      t.string :email
      t.string :civ_style

      t.timestamps
    end
  end
end
