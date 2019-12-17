class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email])
    # binding.pry
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name} you are now logged in!"
      redirect_to '/profile'
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end
end
