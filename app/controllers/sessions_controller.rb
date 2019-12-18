class SessionsController < ApplicationController
  def new
    if current_default?
      flash[:error] = "You are already logged in."
      redirect_to(profile_path)
    elsif current_merchant?
      flash[:error] = "You are already logged in."
      redirect_to(merchant_dashboard_path)
    elsif current_admin?
      flash[:error] = "You are already logged in."
      redirect_to(admin_dashboard_path)
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if authenticated_default_user?(user)
    # if user.authenticate(params[:password]) && user.default?
      # session[:user_id] = user.id
      # flash[:success] = "Welcome back, #{user.name} you are now logged in!"
      successful_login(user)
      redirect_to '/profile'
    elsif authenticated_merchant?(user)
    # elsif user.authenticate(params[:password]) && (user.merchant_employee? || user.merchant_admin?)
      # session[:user_id] = user.id
      # flash[:success] = "Welcome back, #{user.name} you are now logged in!"
      successful_login(user)
      redirect_to '/merchant/dashboard'
    elsif authenticated_admin?(user)
    # elsif user.authenticate(params[:password]) && user.admin?
      # session[:user_id] = user.id
      # flash[:success] = "Welcome back, #{user.name} you are now logged in!"
      successful_login(user)
      redirect_to '/admin/dashboard'
    else
      flash[:error] = "Sorry, your credentials are bad."
      render :new
    end
  end

  private
    def current_merchant?
      current_merchant_employee? || current_merchant_admin?
    end

    def authenticated_default_user?(user)
      user.authenticate(params[:password]) && user.default?
    end

    def authenticated_merchant?(user)
      user.authenticate(params[:password]) && (user.merchant_employee? || user.merchant_admin?)
    end

    def authenticated_admin?(user)
      user.authenticate(params[:password]) && user.admin?
    end

    def successful_login(user)
      session[:user_id] = user.id
      flash[:success] = "Welcome back, #{user.name} you are now logged in!"
    end
end
