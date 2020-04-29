class Comment < ApplicationRecord
  include Likeable

  validates :content, presence: true
  belongs_to :user
  belongs_to :article
end
