class MerchantShow
  attr_reader :order, :merchant

  def initialize(order, merchant)
    @order = order
    @merchant = merchant
  end

  def find_items
    @order.items.where("items.merchant_id = #{@merchant.merchant_id}")
  end

  def find_quantity(item_id)
    ItemOrder.where(item_id: item_id).where(order_id: @order.id).pluck(:quantity).first
  end

  def find_customer
    User.find(@order.user_id)
  end

  def able_to_fulfill(item_id)
    find_item_order_status(item_id) && inventory_check(item_id)
  end

  def inventory_check(item_id)
    Item.find(item_id).inventory >= find_quantity(item_id)
  end

  def find_item_order_status(item_id)
    ItemOrder.where(item_id: item_id).where(order_id: @order.id).pluck(:status).first == 'unfulfilled'
  end

end
