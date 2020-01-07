require './app/models/poros/merchant_show'

class Merchant::OrdersController < Merchant::BaseController
  def show
    order = Order.find(params[:id])
    @merchant_show = MerchantShow.new(order)
  end
end
