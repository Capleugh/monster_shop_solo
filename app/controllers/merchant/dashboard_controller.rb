class Merchant::DashboardController < Merchant::BaseController

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
