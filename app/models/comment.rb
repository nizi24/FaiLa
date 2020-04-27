class Comment < ApplicationRecord
  validates :content, presence: true
  belongs_to :user
  belongs_to :article
  has_many :likes, as: :likeable
end
