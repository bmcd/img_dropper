class UserImageVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :image
  attr_accessible :vote, :user_id, :image_id

  validates :user, :image, :vote, presence: true
  validates :vote, inclusion: { in: [-1, 0, 1] }
end
