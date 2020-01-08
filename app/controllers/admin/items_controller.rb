class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    item = merchant.items.create(item_params)
    if item.save
      flash[:success] = "Item added!"
      redirect_to "/admin/merchants/#{merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      redirect_to "/admin/merchants/#{merchant.id}/items"
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price, :image, :inventory)
  end
end
