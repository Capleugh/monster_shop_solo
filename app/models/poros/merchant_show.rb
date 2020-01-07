class MerchantShow
  attr_reader :order

  def initialize(order)
    @order = order
  end

  def find_items
    @order.items.joins(:item_orders).where("item_orders.order_id = #{@order.id}")
  end

  def find_customer
    User.find(@order.user_id)
  end

end
