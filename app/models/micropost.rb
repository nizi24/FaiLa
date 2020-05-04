class Micropost < ApplicationRecord
  include Likeable

  belongs_to :user

  validates :content, presence: true,
                      length: { maximum: 150 }
end
