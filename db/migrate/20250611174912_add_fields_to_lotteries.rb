class AddFieldsToLotteries < ActiveRecord::Migration[8.0]
  def change
    add_column :lotteries, :priority, :string
    add_column :lotteries, :status, :string
    add_column :lotteries, :meeting_url, :string
    add_column :lotteries, :meeting_code, :string
  end
end
