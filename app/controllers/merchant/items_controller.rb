class Merchant::ItemsController < Merchant::BaseController
  def index
    @items = Item.where(merchant_id: current_user.merchant_id)
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
end
