class User < ApplicationRecord
before_save { self.email = self.email.downcase }
attr_accessor :remember_token
validates :name, presence: true,
          length: { maximum: 50 }
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
validates :email, presence: true,
          uniqueness: { case_sensitive: false },
          length: { maximum: 255 },
          format: { with: VALID_EMAIL_REGEX }
validates :password, length: { minimum: 6 }, allow_nil: true
has_secure_password
has_many :articles

  #remember_tokenを発行して、データベースにハッシュ化されたremember_digestを保存
  def remember
    self.remember_token = User.new_token
    self.update(remember_digest: User.digest(self.remember_token))
  end


  def authenticated?(remember_token)
    return false if self.remember_digest.nil? #異なるブラウザでの操作で生じるエラーを防止
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    self.update(remember_digest: nil)
  end

  #文字列をハッシュ化(デフォルトの計算コストは12)
  def self.digest(string)
    BCrypt::Password.create(string, cost: BCrypt::Engine::DEFAULT_COST)
  end

  #ランダムな文字列を返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
