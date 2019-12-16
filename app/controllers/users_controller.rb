class UsersController < ApplicationController
  def new
  end

  def show
    @user = User.find(session[:user_id])
  end

  def create
    user = User.new(user_params)

    if user.save
      session[:user_id] = user.id
      flash[:success] = "Welcome #{user.name}, you are now registered and logged in."
      redirect_to "/profile"
    else
      flash[:error] = user.errors.full_messages.to_sentence
      render :new
    end
  end

  private
    def user_params
      params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
    end
end