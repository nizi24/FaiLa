class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validates_uniqueness_of :user_id, scope: [ :likeable_type, :likeable_id ]

  scope :micropost_like, ->(user) { find_by(user_id: user.id, likeable_type: 'Micropost') }
  scope :article_like,   ->(user) { find_by(user_id: user.id, likeable_type: 'Article') }
  scope :comment_like,   ->(user) { find_by(user_id: user.id, likeable_type: 'Comment') }

  scope :articles,   -> { where(likeable_type: 'Article') }
  scope :microposts, -> { where(likeable_type: 'Micropost')}
  scope :rank,       -> { group(:likeable_id, :likeable_type).order('count(likeable_id) desc').limit(30).pluck(:likeable_id) }
end
