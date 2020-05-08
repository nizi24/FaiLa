FactoryBot.define do

  factory :article_like, class: 'Like' do
    association :user
    association :likeable, factory: :article
  end

  factory :comment_like, class: 'Like' do
    association :user
    association :likeable, factory: :comment
  end

  factory :micropost_like, class: 'Like' do
    association :user
    association :likeable, factory: :micropost
  end
end
