class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum('quantity')
  end

  def order_status_monitor
    ItemOrder.update_order_status_if_all_fulfilled
  end
end
