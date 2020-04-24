FactoryBot.define do
  factory :article do
    content { "Enter the content of the article" }
    title { "title" }
    association :user
  end
end
