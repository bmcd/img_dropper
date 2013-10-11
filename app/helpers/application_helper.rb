module ApplicationHelper

  def up_selected(model)
    vote = find_vote(model)

    return vote == 1 ? true : false
  end

  def down_selected(model)
    vote = find_vote(model)

    return vote == -1 ? true : false
  end

  def find_vote(model)
    return 0 unless current_user
    if model.class == Image
      vote = UserImageVote.find_by_user_id_and_image_id(current_user.id, model.id)
    else
      vote = UserCommentVote.find_by_user_id_and_comment_id(current_user.id, model.id)
    end

    return vote ? vote.vote : 0
  end
end
