class ImagesController < ApplicationController
  def new
    @image = Image.new

    render :new
  end

  def create
    params[:image] = { "image"=>params[:image] } if params[:dropped]
    @image = Image.new(params[:image])
    @image.user_id = current_user.id if current_user

    if @image.save
      respond_to do |format|
        format.html do
          redirect_to image_url(@image), notice: "Image uploaded Successfully"
        end
        format.json { render json: @image }
      end
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
