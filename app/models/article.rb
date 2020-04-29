class Article < ApplicationRecord
  include Likeable

  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { minimum: 20 }
  belongs_to :user
  has_many :comments
end
