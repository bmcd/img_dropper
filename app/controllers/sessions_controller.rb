class SessionsController < ApplicationController
  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      self.current_user = @user
      redirect_to :root, notice: "Welcome back, #{@user.email}"
    else
      @user ||= User.new
      render :new
    end
  end

  def destroy
    destroy_session

    redirect_to :root, notice: "Come back soon!"
  end
end
