require './app/models/poros/merchant_show'

class Merchant::OrdersController < Merchant::BaseController
  def show
    order = Order.find(params[:id])
    merchant = current_user
    @merchant_show = MerchantShow.new(order, merchant)
  end

  def update
    item = Item.find(params[:item_id])
    item.decrease_item_inventory(params[:quantity])
    ItemOrder.change_item_order_status_to_fulfilled(item.id, params[:id])

    order = Order.find(params[:id])
    if order.all_items_fulfilled?
      order.update_order_status_to_packaged
    end

    flash[:notice] = "#{item.name} has been fulfilled!"
    redirect_to merchant_order_path(params[:id])
  end
end
