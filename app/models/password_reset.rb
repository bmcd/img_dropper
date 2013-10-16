class PasswordReset < ActiveRecord::Base
  extend FriendlyId
  friendly_id :token, use: :slugged
  
  belongs_to :user
  attr_accessible :token, :user_id
  
  validates :token, presence: true
  validate :user
  
  before_validation :ensure_token
  
  private
  
  def ensure_token
    self.token ||= SecureRandom::urlsafe_base64(16)
  end
end
