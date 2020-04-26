module PostArticleSupport

  def post_article(title, content: 'This is a test article')
    click_link '投稿する'
    fill_in 'article[title]', with: title
    fill_in 'article[content]', with: content
    click_button '投稿'
  end

end

RSpec.configure do |config|
  config.include PostArticleSupport
end
