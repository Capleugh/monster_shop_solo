class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = Item.where(merchant_id: current_user.merchant_id)
  end

  def show
  end
end
