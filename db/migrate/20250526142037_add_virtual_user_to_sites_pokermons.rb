class AddVirtualUserToSitesPokermons < ActiveRecord::Migration[8.0]
  def change
    add_reference :sites_pokermons, :virtual_user, null: false, foreign_key: true
  end
end
