class PasswordReset < ActiveRecord::Base
  belongs_to :user
  attr_accessible :token, :user_id
end
