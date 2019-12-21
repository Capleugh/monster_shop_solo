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

  def edit
    @user = current_user
    if params[:info_password] == "info"
      render :info_edit
    else params[:info_password] == "password"
      render :password_edit
    end
  end

  def update
    if params[:update] == "password"
      attempt_password_update
    else params[:update] == "info"
      attempt_info_update
    end
  end

  private
    def user_params
      params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
    end

    def attempt_update(user)
      if user.update(user_params)
        flash[:success] = "Your information has been updated."
        redirect_to profile_path
      else
        flash.now[:error] = user.errors.full_messages.to_sentence + "."
        @user = current_user
        render :info_edit
      end
    end

    def incorrect_password
      flash.now[:error] = "Password is incorrect. Please try again."
      @user = current_user
      render :info_edit
    end

    def require_user
      render file: "/public/404" unless current_user
    end

    def attempt_password_update
      if current_user.update(user_params)
        flash[:success] = "Your password has been updated."
        redirect_to '/profile'
      else
        @user = current_user
        flash[:error] = "Passwords do not match. Please try again."
        render :password_edit
      end
    end

    def attempt_info_update
      if current_user.authenticate(params[:password])
        attempt_update(current_user)
      else
        incorrect_password
      end
    end
end
