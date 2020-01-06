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

    def merchant_params
      params.permit(:name, :address, :city, :state, :zip, :enabled?)
    end

    def change_status_of_merchant(merchant)
      merchant.update(enabled?: false)

      flash[:notice] = "#{merchant.name} is now disabled."
      # redirect_to admin_merchants_path
    end
end
