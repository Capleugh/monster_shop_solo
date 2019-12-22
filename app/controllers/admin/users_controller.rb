class Admin::UsersController < Admin::BaseController

  def index
  end

  def show
    @user = User.find(params[:id])
  end
end
