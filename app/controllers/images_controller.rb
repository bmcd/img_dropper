class ImagesController < ApplicationController
  before_filter :ensure_authorization, only: [:edit, :update, :destroy]
  before_filter :require_logged_in!, only: [:upvote, :downvote]

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
    @images = Image.select("images.*, SUM(user_image_votes.vote) AS votes")
      .joins("LEFT OUTER JOIN user_image_votes ON user_image_votes.image_id = images.id")
      .group("images.id")
    @images.sort_by! do |image|
      votes = image.votes || "0"
      [votes.to_i, image.created_at]
    end.reverse!
  end

  def show
    @image = Image.includes(:comments)
      .select("images.*, SUM(user_image_votes.vote) AS votes")
      .joins("LEFT OUTER JOIN user_image_votes ON user_image_votes.image_id = images.id")
      .group("images.id")
      .where("images.id = #{params[:id]}")
      .first
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

  def upvote
    image_id = params[:id]
    user_id = current_user.id
    @vote = UserImageVote.find_by_user_id_and_image_id(user_id, image_id)
    if @vote
      @vote.vote = (@vote.vote == 1 ? 0 : 1)
    else
      @vote = UserImageVote.new(user_id: user_id, image_id: image_id, vote: 1)
    end

    if @vote.save
      redirect_to :back, notice: "Upvoted Successfully"
    else
      redirect_to :back, notice: "Upvote Failed"
    end
  end

  def downvote
    image_id = params[:id]
    user_id = current_user.id
    @vote = UserImageVote.find_by_user_id_and_image_id(user_id, image_id)
    if @vote
      @vote.vote = (@vote.vote == -1 ? 0 : -1)
    else
      @vote = UserImageVote.new(user_id: user_id, image_id: image_id, vote: -1)
    end

    if @vote.save
      redirect_to :back, notice: "Upvoted Successfully"
    else
      redirect_to :back, notice: "Upvote Failed"
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
