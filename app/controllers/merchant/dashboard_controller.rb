class Merchant::DashboardController < Merchant::BaseController
  before_action :require_not_admin
  before_action :require_not_default

  def index
    @items = Item.where(merchant_id: current_user.merchant_id)
  end

  def show
  end

  private
    def require_not_admin
      render file: '/public/404'unless !current_admin?
    end

    def require_not_default
      render file: "/public/404" unless !current_default?
    end
end
