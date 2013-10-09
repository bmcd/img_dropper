class CommentsController < ApplicationController
  before_filter :require_logged_in!

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.image_id = params[:image_id]

    if @comment.save
      redirect_to :back, notice: "Comment saved"
    else
      redirect_to :back, notice: "Comment not saved"
    end
  end
end
