class CommentsController < ApplicationController
  before_filter :require_logged_in!

  def new
    @image = Image.find(params[:image_id])
    @comment = Comment.new
    @parent_comment_id = params[:parent_comment_id]

    render :new
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.image_id = params[:image_id]

    if @comment.save
      if request.referer =~ /comments/
        redirect_to image_url(id: @comment.image_id), notice: "Comment saved"
      else
        redirect_to :back, notice: "Comment saved"
      end
    else
      redirect_to :back, notice: "Comment not saved"
    end
  end

  def upvote
    comment_id = params[:id]
    user_id = current_user.id
    @vote = UserCommentVote.find_by_user_id_and_comment_id(user_id, comment_id)
    if @vote
      @vote.vote = (@vote.vote == 1 ? 0 : 1)
    else
      @vote = UserCommentVote.new(user_id: user_id, comment_id: comment_id, vote: 1)
    end

    if @vote.save
      redirect_to :back, notice: "Upvoted Successfully"
    else
      redirect_to :back, notice: "Upvote Failed"
    end
  end

  def downvote
    comment_id = params[:id]
    user_id = current_user.id
    @vote = UserCommentVote.find_by_user_id_and_comment_id(user_id, comment_id)
    if @vote
      @vote.vote = (@vote.vote == -1 ? 0 : -1)
    else
      @vote = UserCommentVote.new(user_id: user_id, comment_id: comment_id, vote: -1)
    end

    if @vote.save
      redirect_to :back, notice: "Upvoted Successfully"
    else
      redirect_to :back, notice: "Upvote Failed"
    end
  end

end
