class Merchant::DashboardController < Merchant::BaseController
  before_action :require_not_admin
  before_action :require_not_default

  def index
  end

  private
    def require_not_admin
      render file: '/public/404'unless !current_admin?
    end

    def require_not_default
      render file: "/public/404" unless !current_default?
    end
end
