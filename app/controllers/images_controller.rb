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
    @user = User.new(email: params[:email], password: params[:password])
    @images = Image.select("images.*, SUM(user_image_votes.vote) AS votes")
      .joins("LEFT OUTER JOIN user_image_votes ON user_image_votes.image_id = images.id")
      .group("images.id")
      .order("votes DESC, images.created_at DESC")
      .page(params[:page] || 1)

    if current_user
      @recent_images = current_user.images.order("created_at desc").limit(5)
      @title = "Your Recent Images"
    else
      @recent_images = Image.order("created_at desc").limit(5)
      @title = "Most Recent Images"
    end
    
    expires_now
    
    if request.xhr?
      # render json: @images
      render partial: "image_items", locals: { images: @images}, status: 200
    else
      render :index
    end
  end

  def show
    @image = Image.includes(:comments)
      .select("images.*, SUM(user_image_votes.vote) AS votes")
      .joins("LEFT OUTER JOIN user_image_votes ON user_image_votes.image_id = images.id")
      .group("images.id")
      .where("images.id = #{params[:id]}")
      .first
    @comments_by_parent_id = @image.comments_by_parent_id

    if request.xhr?
      render :show, layout: false
    else
      render :show
    end
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
    handle_vote(1)
  end

  def downvote
    handle_vote(-1)
  end

  private

  def handle_vote(change)
    image_id = params[:id]
    user_id = current_user.id
    @vote = UserImageVote.find_by_user_id_and_image_id(user_id, image_id)
    if @vote
      @vote.vote = (@vote.vote == change ? 0 : change)
    else
      @vote = UserImageVote.new(user_id: user_id, image_id: image_id, vote: change)
    end

    if @vote.save
      if request.xhr?
        render partial: "images/vote_box",
          locals: { up_url: upvote_image_url(id: @vote.image_id),
            down_url: downvote_image_url(id: @vote.image_id),
            votes: UserImageVote.where("image_id = #{@vote.image_id}").sum("vote"),
            model: Image.find(@vote.image_id) }
      else
        redirect_to :back, notice: "Voted Successfully"
      end
    else
      redirect_to :back, notice: "Vote Failed"
    end
  end

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
