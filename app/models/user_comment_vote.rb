class UserCommentVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  attr_accessible :vote, :user_id, :comment_id
end
