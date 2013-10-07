class Image < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title, :album_ids, :image

  has_many :album_images
  has_many :albums, through: :album_images

  has_attached_file :image,
    styles: {
      thumb: "100x100#",
      small: "300x",
      large: "600x"
    },
    url: ":s3_path_url",
    :path => ":class/:id.:style.:extension"

  validates_attachment :image, presence: true,
    size: { in: 0..4.megabytes }
end
