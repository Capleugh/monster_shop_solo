class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    change_merchant_status(merchant)

    redirect_to admin_merchants_path
  end

  private
    def change_merchant_status(merchant)
      if merchant.enabled?
        merchant.update(enabled?: false)
        merchant.items.deactivate_all_items

        flash[:success] = "#{merchant.name} is now disabled."
      else
        merchant.update(enabled?: true)
        merchant.items.activate_all_items

        flash[:success] = "#{merchant.name} is now enabled."
      end
    end
end
