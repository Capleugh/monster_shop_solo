class Merchant::CouponsController < Merchant::BaseController
  def index
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def new
    @merchant = Merchant.find(current_user.merchant_id)
    @coupon = @merchant.coupons.new
  end

  def create
    @merchant = Merchant.find(current_user.merchant_id)
    @coupon = @merchant.coupons.create(coupon_params)
      if @coupon.save
        flash[:success] = "Coupon has been added!"

        redirect_to "/merchant/coupons"
      else
        flash[:error] = @coupon.errors.full_messages.to_sentence
        render :new
      end
    # instance variables have to be here for the sake of rendering new and form_for
  end

  def edit
    @merchant = Merchant.find(current_user.merchant_id)
    @coupon = Coupon.find(params[:id])
    # without merchant, form_for doesn't recognize the path
  end

  def update
    # require "pry"; binding.pry
    @merchant = Merchant.find(current_user.merchant_id)
    # is there another way to do this? ^
    @coupon = Coupon.find(params[:id])
    @coupon.update(coupon_params)
      if @coupon.save
        flash[:success] = "Coupon has been updated!"

        redirect_to merchant_user_coupons_path
      else
        flash[:error] = @coupon.errors.full_messages.to_sentence
        render :edit
      end
    # similarly to create, coupon requires an instance variable because of the render :edit
    # merchant is necessary or it doesn't understand coupon_path maybe you can refactor later.
  end

  def destroy
    coupon = Coupon.find(params[:id])
    coupon.destroy

    flash[:success] = "Coupon has been deleted."
    redirect_to merchant_user_coupons_path
  end

  private
    def coupon_params
      params.require(:coupon).permit(:name, :code, :percent)
    end
end
