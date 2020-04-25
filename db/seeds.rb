
5.times do |n|
  User.create!(
    email: "test#{n + 1}@example.com",
    name: "example user#{n + 1}",
    password: 'password'
  )
end

users = User.all
50.times do |n|
  users.each do |user|
    user.articles.create!(
      title: "テスト投稿#{n + 1}",
      content: '# テスト  **太字**  ***強調太字***  ---  ~~打消し~~'
      )
  end
end
