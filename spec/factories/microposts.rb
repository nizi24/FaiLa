FactoryBot.define do
  factory :micropost do
    content { "MyText" }
    association :user
  end
end
