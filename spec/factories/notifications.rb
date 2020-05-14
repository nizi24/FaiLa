FactoryBot.define do
  factory :notification do
    association :received_user, factory: :user
    association :action_user, factory: :user
    sequence(:message) { |n| "@test#{n}さんがあなたの投稿にいいねしました" }
    sequence(:link) { |n| "/microposts/#{n}"}
    checked { false }
  end
end
