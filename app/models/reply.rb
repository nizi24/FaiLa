class Reply < ApplicationRecord

  belongs_to :sended_micropost,   class_name: 'Micropost'
  belongs_to :received_micropost, class_name: 'Micropost'

  belongs_to :sended_user,   class_name: 'User'
  belongs_to :received_user, class_name: 'User'

  validates :sended_micropost_id, presence: true

  validates :sended_user_id,      presence: true
  validates :received_user_id,    presence: true
end
