class User < ApplicationRecord
  has_many :authentications, dependent: :destroy
  has_many :listings, :dependent => :destroy
  has_many :bids, :dependent => :destroy
  has_secure_password
  validates :email, uniqueness: true, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: "Not a valid email!" }
  validates :password, format:{ with: /(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){8,40}/, message: "Password does not meet requirements!"}
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?
  mount_uploader :avatar, AvatarUploader


  def self.create_with_auth_and_hash(authentication, auth_hash)
      user = self.create!(
        username: auth_hash["name"],
        email: auth_hash["extra"]["raw_info"]["email"],
        password: SecureRandom.hex(4)
      )
      user.authentications << authentication
      return user
  end

    # grab fb_token to access Facebook for user data
  def fb_token
      x = self.authentications.find_by(provider: 'facebook')
      return x.token
      unless x.nil?
  end
end

  def set_default_role
    self.role = :user
  end
end
