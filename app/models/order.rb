class Order <ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  enum status: [:packaged, :pending, :shipped, :cancelled]

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_items
    item_orders.sum('quantity')
  end

  def all_items_fulfilled?
    item_orders.count == item_orders.where(status: 'fulfilled').count
  end

  def update_order_status_to_packaged
    update(status: 0)
  end

  def self.order_by_status
    order(:status)
  end
end
