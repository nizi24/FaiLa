class Micropost < ApplicationRecord
  include Likeable

  belongs_to :user
  has_many_attached :images
  has_many :send_replies,    class_name:  'Reply',
                             foreign_key: 'sended_micropost_id',
                             dependent:    :destroy

  has_many :receive_replies, class_name:  'Reply',
                             foreign_key: 'received_micropost_id',
                             dependent:    :destroy

  has_many :sended_replies,   through: :send_replies,
                              source:  :received_micropost

  has_many :received_replies, through: :receive_replies,
                              source:  :sended_micropost

  validates :content, presence: true,
                      length: { maximum: 280 }

  validates :images, content_type:  { in: %w[image/jpeg image/gif image/png image/heic],
                                    message: '有効な形式の画像を選択してください'},
                     size:          { less_than: 10.megabytes,
                                    message: '10MB以下の画像を選択してください'},
                     limit:         { max: 4 }

  scope :user_have,     -> (params)                 { where(user_id: params) }
  scope :newest,        ->                          { order(created_at: :desc) }
  scope :pages,         -> (params, per = 30)       { paginate(page: params, per_page: per) }
  scope :user_have_all, -> (params, page, per = 20) { user_have(params).newest.pages(page, per) }
  scope :all_page,      -> (page, per = 30)         { all.newest.pages(page) }

  def self.rank(time)
    Micropost.find(Like.microposts.rank).select do |micropost|
      time.ago.beginning_of_day < micropost.created_at
    end
  end

  def self.search(word)
    Micropost.where(['content LIKE ?', "%#{word}%"]).newest
  end

end
