FactoryBot.define do
  factory :user do
    name { 'Foo Bar'}
    sequence(:unique_name) { |n| "tester#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }
  end
end
