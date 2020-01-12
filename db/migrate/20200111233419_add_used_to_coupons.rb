class AddUsedToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_column :coupons, :used?, :boolean, default: false
  end
end
