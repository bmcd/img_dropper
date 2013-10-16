class PasswordResetsController < ApplicationController
  def new
    render :new
  end
  
  def create
    @user = User.find_by_email(params[:email])
    
    if @user
      @user.send_password_reset_email
      redirect_to :root, notice: "Email sent."
    else
      redirect_to new_password_reset_url, notice: "Invalid email address."
    end
  end
  
  def edit
    @password_reset = PasswordReset.find_by_token(params[:id])
    if @password_reset
      @user = @password_reset.user
      render :edit
    elsif 
      redirect_to :root, notice: "Invalid password reset token"
    end
  end
end
