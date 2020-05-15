FactoryBot.define do
  factory :user do
    name { 'Foo Bar'}
    sequence(:unique_name) { |n| "tester#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }

    after(:create) { |user| FactoryBot.create(:setting, user: user) }
  end
end
