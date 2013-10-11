class CommentsController < ApplicationController
  before_filter :require_logged_in!

  def new
    if request.xhr?
      render partial: "images/comment_form",
        locals: { image_id: params[:image_id], parent_comment_id: params[:parent_comment_id] }
    else
      @image = Image.find(params[:image_id])
      @comment = Comment.new
      @parent_comment_id = params[:parent_comment_id]

      render :new
    end
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.image_id = params[:image_id]

    if @comment.save
      if request.xhr?
        render partial: 'images/comment',
          locals: { image_id: @comment.image_id, comment: @comment, comments_by_parent_id: { @comment.id => []} }
      elsif request.referer =~ /comments/
        redirect_to image_url(id: @comment.image_id), notice: "Comment saved"
      else
        redirect_to :back, notice: "Comment saved"
      end
    else
      redirect_to :back, notice: "Comment not saved"
    end
  end

  def upvote
    handle_vote(1)
  end

  def handle_vote(change)
    comment_id = params[:id]
    user_id = current_user.id
    @vote = UserCommentVote.find_by_user_id_and_comment_id(user_id, comment_id)
    if @vote
      @vote.vote = (@vote.vote == change ? 0 : change)
    else
      @vote = UserCommentVote.new(user_id: user_id, comment_id: comment_id, vote: change)
    end

    if @vote.save
      if request.xhr?
        render partial: "images/vote_box",
          locals: { up_url: upvote_comment_url(id: @vote.comment_id),
            down_url: downvote_comment_url(id: @vote.comment_id),
            votes: UserCommentVote.where("comment_id = #{@vote.comment_id}").sum("vote"),
            model: Comment.find(@vote.comment_id) }
      else
        redirect_to :back, notice: "Upvoted Successfully"
      end
    else
      redirect_to :back, notice: "Upvote Failed"
    end
  end

  def downvote
    handle_vote(-1)
  end

end
