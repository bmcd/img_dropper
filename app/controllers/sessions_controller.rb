class SessionsController < ApplicationController
  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenticate(params[:password])
      self.current_user = @user
      if request.xhr?
        render partial: "layouts/top_bar"
      else
        redirect_to :root, notice: "Welcome back, #{@user.email}"
      end
    else
      @user = User.new
      @user.errors[:invalid] = "email/password combination"
      if request.xhr?
        render partial: "sessions/login", status: 422
      else
        render :new
      end
    end
  end

  def destroy
    destroy_session

    redirect_to :root, notice: "Come back soon!"
  end
end
