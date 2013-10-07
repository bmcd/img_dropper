class Image < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title, :album_ids, :image

  has_many :album_images
  has_many :albums, through: :album_images

  validates_attachment :image, presence: true,
    size: { in: 0..4.megabytes }
end
