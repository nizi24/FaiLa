class User < ApplicationRecord
before_save { self.email = self.email.downcase }
before_save { self.unique_name = self.unique_name.downcase }
attr_accessor :remember_token

validates :name,
          presence:   true,
          length:     { maximum: 50 }

VALID_UNIQUE_NAME_REGEX = /\A[a-z0-9_]+\z/i
validates :unique_name,
          presence:   true,
          length:     { in: 5..15 },
          uniqueness:   { case_sensitive: false },
          format:     { with: VALID_UNIQUE_NAME_REGEX, message: '半角英数とアンダースコアのみ使用できます' }

VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
validates :email,
          presence:     true,
          uniqueness:   { case_sensitive: false },
          length:       { maximum: 255 },
          format:       { with: VALID_EMAIL_REGEX }

validates :password,
          length:       { minimum: 6 },
          allow_nil:    true

validates :icon, content_type: { in: %w[image/jpeg image/gif image/png image/heic],
                                message: '有効な形式の画像を選択してください'},
                size:          { less_than: 5.megabytes,
                                message: '5MB以下の画像を選択してください'}
has_secure_password

has_one_attached :icon
has_many :articles
has_many :microposts
has_many :comments
has_many :likes
has_many :active_relationships,   class_name:   'Relationship',
                                  foreign_key:  'follower_id',
                                  dependent:    :destroy

has_many :passive_relationships,  class_name:   'Relationship',
                                  foreign_key:  'followed_id',
                                  dependent:    :destroy

has_many :following, through: :active_relationships,
                     source:  :followed

has_many :followers, through: :passive_relationships,
                     source:  :follower

  def follow(other_user)
    self.following << other_user
  end

  def unfollow(other_user)
    self.following.delete(other_user)
  end

  def following?(other_user)
    self.following.include?(other_user)
  end

  def already_liked?(object)
    self.likes.exists?(User.sort_object(object))
  end

  def self.sort_object(object)
    object_type = { likeable_id: object.id }
    case object
    when Article
      object_type.merge({ likeable_type: 'Article' })
    when Comment
      object_type.merge({ likeable_type: 'Comment'})
    when Micropost
      object_type.merge({ likeable_type: 'Micropost'})
    else
      object_type = nil
    end
  end

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
