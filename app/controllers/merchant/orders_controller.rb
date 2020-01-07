require './app/models/poros/merchant_show'

class Merchant::OrdersController < Merchant::BaseController
  def show
    order = Order.find(params[:id])
    merchant = current_user
    @merchant_show = MerchantShow.new(order, merchant)
  end
end
