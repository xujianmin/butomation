class CreateLotteries < ActiveRecord::Migration[8.0]
  def change
    create_table :lotteries do |t|
      t.string :title
      t.datetime :started_at
      t.datetime :ended_at
      t.string :target_url
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
