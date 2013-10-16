class UsersController < ApplicationController
  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      self.current_user = @user
      if request.xhr?
        render partial: "layouts/top_bar"
      else
        redirect_to :back, notice: "User Created"
      end
    else
      if request.xhr?
        render partial: "users/signup"
      else
        render :new
      end
    end
  end
  
  def update
    @user = User.find(params[:id])
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      redirect_to new_session_url, notice: "Password Successfully Changed"
    else
      redirect_to :back, notice: @user.errors.full_messages.to_sentence
    end
  end

  def show
    @user = User.includes(:images).find(params[:id])

    render :show
  end
end
