class RemoveOwnerFromLotteries < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :lotteries, column: :owner_id
    remove_reference :lotteries, :owner
  end
end
