class ItemOrder < ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity, :status

  belongs_to :item
  belongs_to :order

  enum status: [:unfulfilled, :fulfilled]

  def subtotal
    price * quantity
  end

  def self.change_status_to_unfulfilled
    update(status: 0)
  end

  def self.change_item_order_status_to_fulfilled(item_id, order_id)
    self.where(order_id: order_id).where(item_id: item_id).update(status: 1)
  end
end
