class Admin::OrdersController < Admin::BaseController

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    order = Order.find(params[:id])
    if order.status == 'pending'
      order.item_orders.change_status_to_unfulfilled
      reset_inventory(order)
      change_order_status_to_cancelled(order)
    end
  end

  private
    def change_order_status_to_cancelled(order)
      order.update(status: 3)
      flash[:success] = "#{order.id} has been cancelled."
      redirect_to admin_path
    end

    def reset_inventory(order)
      order.items.each do |item|
        quantity = item.quantity_ordered(order)
        item.increase_item_inventory(quantity)
      end
    end
end
