class Album < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title, :image_ids

  has_many :album_images
  has_many :images, through: :album_images

  validates :title, presence: true
end
