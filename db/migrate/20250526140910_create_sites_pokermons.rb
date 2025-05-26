class CreateSitesPokermons < ActiveRecord::Migration[8.0]
  def change
    create_table :sites_pokermons do |t|
      t.string :nickname
      t.string :kana
      t.string :registry_cellphone
      t.string :registry_postcode
      t.string :registry_fandi
      t.string :reg_password

      t.timestamps
    end
  end
end
