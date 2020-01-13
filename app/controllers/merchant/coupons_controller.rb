class Merchant::CouponsController < Merchant::BaseController
  def index
  end

  def show
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @coupon = @merchant.coupons.new
    # @coupon = Coupon.new







    # why do both work?
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    @coupon = @merchant.coupons.create(coupon_params)
      if @coupon.save
        flash[:success] = "Coupon added!"

        redirect_to "/merchant/coupons"
      else
        flash[:error] = @coupon.errors.full_messages.to_sentence
        render :new
      end
  end

  private
    def coupon_params
      params.require(:coupon).permit(:name, :code, :percent)
      # why does this make the merchant.name nil class error go away?
    end
end
