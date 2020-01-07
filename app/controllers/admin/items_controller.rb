class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
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
end
