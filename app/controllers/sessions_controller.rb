class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password]) && user.default?
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name} you are now logged in!"
      redirect_to '/profile'
    elsif user.authenticate(params[:password]) && (user.merchant_employee? || user.merchant_admin?)
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name} you are now logged in!"
      redirect_to '/merchant/dashboard'
    elsif user.authenticate(params[:password]) && user.admin?
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name} you are now logged in!"
      redirect_to '/admin/dashboard'
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:cart)
    flash[:notice] = "Goodbye, you are now logged out."
    redirect_to '/'
  end
end
