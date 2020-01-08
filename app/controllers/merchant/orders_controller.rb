require './app/models/poros/merchant_show'

class Merchant::OrdersController < Merchant::BaseController
  def show
    order = Order.find(params[:id])
    merchant = current_user
    @merchant_show = MerchantShow.new(order, merchant)
  end

  def update
    item = Item.find(params[:item_id])
    # Item.decrease_item_inventory(params[:item_id], params[:quantity])
    #the line below replaces the line above with the new model method
    item.decrease_item_inventory(params[:quantity])
    ItemOrder.change_item_order_status_to_fulfilled(item.id, params[:id])
#there is no feature test that tests once all items in an order are fulfilled, the order status changes to packaged
    # Order.update_order_status_to_packaged

    order = Order.find(params[:id])
    if order.all_items_fulfilled?
      order.update_order_status_to_packaged
    end

    flash[:notice] = "#{item.name} has been fulfilled!"
    redirect_to merchant_order_path(params[:id])
  end
end
