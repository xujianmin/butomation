class AddBirthdateToVirtualUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :virtual_users, :birthdate, :date
    add_column :virtual_users, :domain, :string
  end
end
