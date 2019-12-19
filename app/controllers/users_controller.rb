class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def show
    if !current_user
      require_user
    else
      @user = current_user
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name}, you are now registered and logged in."
      redirect_to "/profile"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  private
    def user_params
      params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
    end

    def require_user
      render file: "/public/404" unless current_user
    end
end
