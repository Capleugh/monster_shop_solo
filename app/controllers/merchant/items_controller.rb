class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = Item.where(merchant_id: current_user.merchant_id)
  end

  def show
  end

  def update
    item = Item.find(params[:id])
    if item.toggle!(:active?)
      flash[:success] = "#{item.name} is no longer for sale."
    end
    
    redirect_to merchant_items_path
  end
end
