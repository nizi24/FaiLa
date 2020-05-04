module PostArticleSupport

  def post_article(title, content: 'This is a test article')
    click_link '投稿する', match: :first
    click_button '記事を書く'
    fill_in 'article[title]', with: title
    fill_in 'article[content]', with: content
    within '.form-group' do
      click_button '投稿'
    end
  end

end

RSpec.configure do |config|
  config.include PostArticleSupport
end
