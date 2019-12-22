class ChangeStatusOnOrders < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :status, :integer, default: 1
  end
end
