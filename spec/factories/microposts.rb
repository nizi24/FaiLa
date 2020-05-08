FactoryBot.define do
  factory :micropost do
    content { "MyText" }
    association :user

    trait :have_one_likes do
      after(:create) { |micropost| create_list(:micropost_like, 1, likeable: micropost)}
    end

    trait :have_three_likes do
      after(:create) { |micropost| create_list(:micropost_like, 3, likeable: micropost)}
    end

    trait :have_five_likes do
      after(:create) { |micropost| create_list(:micropost_like, 5, likeable: micropost)}
    end

  end
end
