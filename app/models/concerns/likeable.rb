module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable
  end

  def likes_total
    raise NotImplementedError
  end
end
