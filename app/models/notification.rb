class Notification < ApplicationRecord
  belongs_to :received_user, class_name: 'User'
  belongs_to :action_user,   class_name: 'User', optional: true

  validates :message, uniqueness: { scope: :link }

  scope :newest, -> { order(created_at: :desc) }
end
