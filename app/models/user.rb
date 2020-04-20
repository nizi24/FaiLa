class User < ApplicationRecord
validates :name, presence: true,
          length: { maximum: 50 }
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
validates :email, presence: true,
          uniqueness: { case_sensitive: false },
          length: { maximum: 255 },
          format: { with: VALID_EMAIL_REGEX }
validates :password, length: { minimum: 6 }, allow_nil: true
has_secure_password

end
