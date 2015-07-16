class Session < ActiveRecord::Base
  before_validation :ensure_session_token
  validates :user_id, :session_token, presence: true
  belongs_to :user

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def generate_session_token
    SecureRandom.urlsafe_base64
  end

  def destroy_session!
    self.destroy!
  end
end
