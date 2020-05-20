FactoryBot.define do
  factory :contact do
    name { "foobar" }
    email { 'tester@example.com'}
    message { "Thank you." }
  end
end
