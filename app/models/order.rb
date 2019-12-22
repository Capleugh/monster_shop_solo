class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: [:pending, :packaged, :shipped, :cancelled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum('quantity')
  end

  def self.update_order_status_to_packaged
    total_items_in_order = ItemOrder.group(:order_id).count
    fulfilled_items_in_order = ItemOrder.where(status: 'fulfilled').group(:order_id).count
    ids = []
    fulfilled_items_in_order.each do |order_id, quantity|
      if total_items_in_order[order_id] == quantity
        ids << order_id
      end
    end
    ids.each do |id|
      order = self.find(id)
      order.update(status: 1)
    end
  end

  def self.order_by_status
    Order.order(:status)
  end
end
