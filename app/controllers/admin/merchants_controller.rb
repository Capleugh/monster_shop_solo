class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def show
    # require "pry"; binding.pry
    @merchant = Merchant.find(params[:id])
  end
end
