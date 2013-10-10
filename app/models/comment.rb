class Comment < ActiveRecord::Base
  attr_accessible :body, :parent_comment_id, :user_id, :image_id

  belongs_to :user
  belongs_to :image

  has_many :user_comment_votes
  has_many :child_comments,
    class_name: "Comment",
    foreign_key: :parent_comment_id,
    primary_key: :id

  validates :user_id, :image_id, :body, presence: true

  def votes
    self.user_comment_votes.sum(:vote)
  end
end
