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

validates :profile,
          length:       { maximum: 160 }

validates :icon, content_type: { in: %w[image/jpeg image/gif image/png image/heic],
                                message: '有効な形式の画像を選択してください'},
                size:          { less_than: 5.megabytes,
                                message: '5MB以下の画像を選択してください'}
has_secure_password

has_one_attached :icon
has_many :articles,   dependent: :destroy
has_many :microposts, dependent: :destroy
has_many :comments,   dependent: :destroy
has_many :likes,      dependent: :destroy
has_one :setting,     dependent: :destroy

# Relationship
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

# Reply
has_many :send_replies,    class_name:  'Reply',
                           foreign_key: 'sended_user_id',
                           dependent:   :destroy

has_many :receive_replies, class_name:  'Reply',
                           foreign_key: 'received_user_id',
                           dependent:   :destroy

has_many :sended_replies,   through: :send_replies,
                            source:  :received_micropost

has_many :received_replies, through: :receive_replies,
                            source:  :sended_micropost

# Notification
has_many :action,   class_name:  'Notification',
                    foreign_key: 'action_user_id',
                    dependent:   :destroy

has_many :notices,  class_name:  'Notification',
                    foreign_key: 'received_user_id',
                    dependent:   :destroy

scope :newest, -> { order(created_at: :desc) }

  #未読の通知があればtrue
  def nonchecked?
    self.notices.find_by(checked: false)
  end

  def following_feed
    following_feed_items = following_microposts_feed + following_articles_feed
    following_feed_items.sort_by { |item|
      item.created_at
    }.reverse!
  end

  def following_microposts_feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    following_microposts = Micropost.where("user_id IN (#{following_ids})", user_id: id).newest
  end

  def following_articles_feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Article.where("user_id IN (#{following_ids})", user_id: id).newest
  end

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

  def self.search(word)
    User.where(['name LIKE ?', "%#{word}%"]).newest
  end

  def self.unique_name_search(word)
    User.where(['unique_name LIKE ?', "%#{word}%"]).newest
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
