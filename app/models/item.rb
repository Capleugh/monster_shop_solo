class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than_or_equal_to: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.find_active_items
    where(active?: true)
  end

  def self.top_five_items
    select("items.*, sum(quantity)").where(active?: true).joins(:item_orders).group(:id).order("sum desc").limit(5)
  end

  def self.bottom_five_items
    select("items.*, sum(quantity)").where(active?: true).joins(:item_orders).group(:id).order("sum").limit(5)
  end

  def decrease_item_inventory(quantity)
    current_inventory = inventory.to_i
    update(inventory: (current_inventory - quantity.to_i))
  end

  def increase_item_inventory(quantity)
    current_inventory = inventory.to_i
    update(inventory: (current_inventory + quantity.to_i))
  end

  def quantity_ordered(order)
    ItemOrder.where(order_id: order.id).where(item_id: self.id).first.quantity
  end

  def self.deactivate_all_items
    update(active?: false)
  end

  def self.activate_all_items
    update(active?: true)
  end
end
