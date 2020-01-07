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
    merchant.items.deactivate_all_items


    redirect_to admin_merchants_path
  end

  private
    def change_status_of_merchant(merchant)
      if merchant.enabled?
        merchant.update(enabled?: false)

        flash[:success] = "#{merchant.name} is now disabled."
      else
        merchant.update(enabled?: true)

        flash[:success] = "#{merchant.name} is now enabled."
      end
    end


end

#
# def update
#   require "pry"; binding.pry
#   merchant = Merchant.find(params[:merchant_id])
#   item = merchant.items.find(params[:id])
#
#   if deactivate?
#     deactivate(item)
#   elsif activate?
#     activate(item)
#   end
#   # redirect_to admin_merchants_path
# end
#
#   private
#     def deactivate?
#       params[:status] == "deactivate"
#     end
#
#     def deactivate(item)
#       item.toggle!(:active?)
#     end
#
#     def activate?
#       params[:status] == "activate"
#     end
#
#     def activate(item)
#       item.toggle!(:active?)
#     end
