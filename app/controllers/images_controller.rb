class ImagesController < ApplicationController
  def new
    @image = Image.new

    render :new
  end

  def create
    @image = Image.new(params[:image])
    @image.user_id = current_user.id if current_user

    if @image.save
      redirect_to image_url(@image), notice: "Image uploaded Successfully"
    else
      render :new
    end
  end

  def index
    @images = Image.all
  end

  def show
    @image = Image.find(params[:id])

    render :show
  end
end
