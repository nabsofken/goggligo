class UserIdentity < ActiveRecord::Base
  before_save :ensure_access_token
  belongs_to :user

  validates :device_id, :user_id, presence: true
  validates :device_id, uniqueness: {scope: [:user_id]}

  private

  def ensure_access_token
    generate_authentication_token if access_token.blank?
  end

  def generate_authentication_token
    self.access_token = SecureRandom.base64 64
  end

end
