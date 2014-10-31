class User < ActiveRecord::Base
  
  attr_reader :password
  validates :email, :session_token, :password_digest, presence: true
  validates :email, :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  
  has_many :notes
  
  after_initialize :reset_session_token!, :generate_activation_token!
  
  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
  end
  
  def generate_activation_token!
    self.activation_token ||= SecureRandom::urlsafe_base64
  end
  
  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end
  
  def password_digest
    BCrypt::Password.new(super)
  end
  
  def is_password?(pw)
    password_digest.is_password?(pw)
  end
  
  def self.find_by_credentials(email, pw)
    u = User.find_by(email: email)
    return u if u.try(:is_password?, pw)
    nil
  end
  
end
