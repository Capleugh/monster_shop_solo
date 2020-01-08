class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = Item.where(merchant_id: current_user.merchant_id)
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @item = @merchant.items.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    merchant.items.create(item_params)
    flash[:success] = "Item added!"
    redirect_to merchant_items_path
  end

  def show
  end

  def update
    item = Item.find(params[:id])

    if deactivate?
      deactivate(item)
    elsif activate?
      activate(item)
    end

    redirect_to merchant_items_path
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "#{item.name} has been deleted."

    redirect_to merchant_items_path
  end

  private
    def deactivate?
      params[:status] == "deactivate"
    end

    def deactivate(item)
      if item.toggle!(:active?)
        flash[:success] = "#{item.name} is no longer for sale."
      end
    end

    def activate?
      params[:status] == "activate"
    end

    def activate(item)
      if item.toggle!(:active?)
        flash[:success] = "#{item.name} is available for sale."
      end
    end

    def item_params
      params.require(:item).permit(:name, :description, :price, :image, :inventory)
    end
end
