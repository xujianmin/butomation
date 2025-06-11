class AddOwnerToLotteries < ActiveRecord::Migration[8.0]
  def change
    add_reference :lotteries, :owner, null: true, foreign_key: { to_table: :users }
  end
end
