class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order

  enum status: [:unfulfilled, :fulfilled]

  def subtotal
    price * quantity
  end

  def self.change_items_status_to_unfilled(order)
    self.where(order_id: order.id).update(status: 0)
  end

end
