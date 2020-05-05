class Micropost < ApplicationRecord
  include Likeable

  belongs_to :user

  validates :content, presence: true,
                      length: { maximum: 280 }

  scope :user_have,     -> (params)                 { where(user_id: params) }
  scope :newest,        ->                          { order(created_at: :desc) }
  scope :pages,         -> (params, per = 30)       { paginate(page: params, per_page: per) }
  scope :user_have_all, -> (params, page, per = 20) { user_have(params).newest.pages(page, per) }
  scope :all_page,      -> (page, per = 30)         { all.newest.pages(page) }

end
