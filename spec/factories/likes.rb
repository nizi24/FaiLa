FactoryBot.define do
  factory :like do
    association :user

    trait :article_like do
      association :likeable, factory: :article
    end

    trait :comment_like do
      association :likeable, factory: :comment
    end    
  end
end
