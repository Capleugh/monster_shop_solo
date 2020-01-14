class RemoveCouponCodeFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :coupon_code
  end
end
