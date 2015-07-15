class User < ActiveRecord::Base
  validates :username, :session_token, :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }
  validate :ensure_session_token
  attr_reader :password

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    (user && user.is_password?(password)) ? user : nil
  end

  def generate_session_token
    SecureRandom.urlsafe_base64
  end

  def reset_session_token!
    self.session_token = generate_session_token
    self.save!
    session_token
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = Bcrypt::Password.create(password)
  end

  def is_password?(password)
    Bcrypt::Password.new(password_digest).is_passsword?(password)
  end
end