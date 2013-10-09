require 'open-uri'

class Image < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title, :album_ids, :image, :image_url, :user_id
  attr_accessor :image_url

  has_many :album_images
  has_many :albums, through: :album_images
  has_many :comments

  before_validation :download_remote_image, if: :image_url_provided?

  has_attached_file :image,
    styles: {
      thumb: "140x140#",
      small: "300x",
      large: "600x"
    },
    url: ":s3_path_url",
    :path => ":class/:id.:style.:extension"



  validates :image_remote_url, presence: true, if: :image_url_provided?

  validates_attachment :image, presence: true,
    size: { in: 0..1.megabytes }

  def ensure_authorization_token
    self.authorization_token ||= SecureRandom::urlsafe_base64(16)
  end

  def image_url_provided?
    self.image_url && !self.image_url.blank?
  end

  def download_remote_image
    io = open(URI.parse(self.image_url))
    def io.original_filename
      base_uri.path.split('/').last
    end
    self.image = io
    self.image_remote_url = self.image_url
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

  def comments_by_parent_id
    comment_hash = { nil => [] }
    comments.each do |comment|
      comment_hash[comment.parent_comment_id] ||= []
      comment_hash[comment.id] ||= []
      comment_hash[comment.parent_comment_id] << comment
    end

    comment_hash
  end
end
