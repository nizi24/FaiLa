FactoryBot.define do
  factory :micropost do
    content { "MyText" }
    association :user

    trait :have_one_like do
      after(:create) { |micropost| create_list(:micropost_like, 1, likeable: micropost)}
    end

    trait :have_three_likes do
      after(:create) { |micropost| create_list(:micropost_like, 3, likeable: micropost)}
    end

    trait :have_five_likes do
      after(:create) { |micropost| create_list(:micropost_like, 5, likeable: micropost)}
    end

    trait :yesterday do
      created_at { 1.day.ago }
    end

    trait :three_days_before do
      created_at { 3.days.ago }
    end

    trait :one_week_before do
      created_at { 1.week.ago }
    end

    trait :one_month_before do
      created_at { 1.month.ago }
    end
  end
end
