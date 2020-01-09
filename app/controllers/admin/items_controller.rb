class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.create(item_params)
    if @item.save
      flash[:success] = "Item added!"
      redirect_to "/admin/merchants/#{@merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    item = Item.find(params[:id])
    item.destroy
    flash[:success] = "#{item.name} has been deleted."
    redirect_to admin_merchant_items_path(merchant)
  end

  def edit
    @item = Item.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    if params[:status].nil?
      update_item_info(@item)
    else
      update_status(@item)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :price, :image, :inventory)
  end

  def default_image
    'https://scontent-den4-1.cdninstagram.com/v/t51.2885-15/e35/11375785_1097843546897273_287775595_n.jpg?_nc_ht=scontent-den4-1.cdninstagram.com&_nc_cat=105&_nc_ohc=yrczfty57n0AX-7OByN&oh=d6298df08426babd3eb105ea14b12329&oe=5E9B3359'
  end

  def update_status(item)
    if deactivate?
      deactivate(item)
    elsif activate?
      activate(item)
    end
    redirect_to "/admin/merchants/#{@merchant.id}/items"
  end

  def update_item_info(item)
    if item.update(item_params)
      if params[:image] == ""
        item.update(image: default_image)
      end
      redirect_to "/admin/merchants/#{@merchant.id}/items"
      flash[:success] = 'Item Has Been Updated'
    else
      flash[:error] = item.errors.full_messages.to_sentence
      redirect_back(fallback_location: "/admin/merchants/#{@merchant.id}/items")
    end
  end

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
