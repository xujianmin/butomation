class AddIndexesForVirtualUsersCount < ActiveRecord::Migration[8.0]
  def change
    # 只添加 attendances 表缺失的索引
    add_index :attendances, [ :lottery_id, :status ], name: 'index_attendances_on_lottery_id_and_status', if_not_exists: true
    add_index :attendances, [ :user_id, :status ], name: 'index_attendances_on_user_id_and_status', if_not_exists: true
    add_index :attendances, [ :lottery_id, :status, :user_id ], name: 'index_attendances_on_lottery_status_user', if_not_exists: true
  end
end
