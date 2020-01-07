class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    change_status_of_merchant(merchant)

    redirect_to admin_merchants_path
  end

  private
    def change_status_of_merchant(merchant)
      merchant.update(enabled?: false)

      flash[:success] = "#{merchant.name} is now disabled."
    end
end
