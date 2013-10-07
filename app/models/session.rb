class Session < ActiveRecord::Base
  belongs_to :user
  attr_accessible :session_token

  before_validation :ensure_session_token

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end

  validate :user
  validates :session_token, presence: true
end
