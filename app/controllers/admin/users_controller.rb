class Admin::UsersController < Admin::BaseController

  def index
  end

  def show
    @user = User.find(params[:id])

    redirect_to(admin_user_path)
  end
end
