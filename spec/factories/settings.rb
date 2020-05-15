FactoryBot.define do
  factory :setting do
    association :user
    notice_of_like { true }
    notice_of_comment { true }
    notice_of_reply { true }
    notice_of_follow { true }
  end
end
