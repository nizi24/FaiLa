class Article < ApplicationRecord
  include Likeable

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { minimum: 20 }
  belongs_to :user
  has_many :comments

  scope :user_have,     -> (params)                 { where(user_id: params) }
  scope :newest,        ->                          { order(created_at: :desc) }
  scope :pages,         -> (params, per = 30)       { paginate(page: params, per_page: per) }
  scope :user_have_all, -> (params, page, per = 20) { user_have(params).newest.pages(page, per) }
  scope :all_page,      -> (page, per = 30)         { all.newest.pages(page) }

  def self.rank(time)
    Article.find(Like.articles.rank).select do |article|
      time.ago.beginning_of_day < article.created_at
    end
  end

end
