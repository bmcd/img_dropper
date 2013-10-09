class ImagesController < ApplicationController
  before_filter :ensure_authorization, only: [:edit, :update, :destroy]

  def new
    @image = Image.new

    render :new
  end

  def create
    params[:image] = { "image"=>params[:image] } if params[:dropped]
    @image = Image.new(params[:image])
    if current_user
      @image.user_id = current_user.id
    else
      @image.ensure_authorization_token
    end

    if @image.save
      respond_to do |format|
        format.html do
          redirect_to edit_image_url(@image, authorization_token: @image.authorization_token), notice: "Image uploaded Successfully"
        end
        format.json { render json: @image.to_json }
      end
    else
      render :new
    end
  end

  def index
    @images = Image.all
  end

  def show
    @image = current_image
    @comments_by_parent_id = @image.comments_by_parent_id

    render :show
  end

  def edit
    @image = current_image
    @token = params[:authorization_token]

    render :edit
  end

  def update
    @image = current_image

    if @image.update_attributes(params[:image])
      redirect_to image_url(@image), notice: "Image successfully edited."
    else
      render :edit
    end
  end

  def destroy
    @image = current_image

    if @image.destroy
      if request.referer =~ /user/
        redirect_to :back, notice: "Image Successfully Deleted"
      else
        redirect_to :root, notice: "Image Successfully Deleted"
      end
    else
      redirect_to :back, notice: "Something went wrong."
    end
  end

  private

  def current_image
    @current_image ||= Image.find(params[:id])
  end

  def ensure_authorization
    unless (current_user && current_user.id == current_image.user_id) ||
          params[:authorization_token] == current_image.authorization_token
      redirect_to :root, notice: "You do not have permission."
    end
  end
end
