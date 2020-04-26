FactoryBot.define do
  factory :comment do
    content { "Impressive." }
    association :user
    association :article
  end
end
