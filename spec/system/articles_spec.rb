require 'rails_helper'

RSpec.describe "Articles", js: true, type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  context 'ログインしたユーザーが記事を作成するとき' do
    it '作成に成功すること' do
      log_in_as user
      click_link '投稿する', match: :first
      click_button '記事を書く'

      expect {
        fill_in 'article[title]', with: 'Test article'
        fill_in 'article[content]', with: 'This is a test article'
        within '.form-group' do
          click_button '投稿'
        end
      }.to change(user.articles, :count).by(1)

      expect(page).to have_content 'Test article'
      expect(page).to have_content user.name
    end
  end

  context 'ログインしたユーザーが自分の記事を編集するとき' do
    it '編集に成功すること' do
      article = FactoryBot.create(:article, user: user,
                                  title: 'posting test',
                                  content: 'Testing article functionality')

      log_in_as user
      visit article_path(article)
      click_link '編集'

      expect(page).to have_field 'article[title]', with: article.title
      expect(page).to have_field 'article[content]', with: article.content
      fill_in 'article[title]', with: 'update article'
      fill_in 'article[content]', with: 'Testing article functionality'
      click_button '変更'

      expect(page).to have_content '更新に成功しました'
      expect(page).to have_content 'update article'
      expect(page).to have_content 'Testing article functionality'
    end
  end

  context 'ログインしたユーザーが記事を削除するとき' do
    it '他のユーザーの記事に削除ボタンがないこと' do
      other_user = FactoryBot.create(:user)

      log_in_as other_user
      post_article 'other article'
      log_out_as other_user

      log_in_as user
      visit articles_path
      expect(page).to have_content 'other article'
      expect(page).to_not have_button '削除'

      visit user_path(other_user)
      expect(page).to_not have_button '削除'
    end

    it '自分の記事は削除できること' do
      log_in_as user
      post_article 'Test article'
      click_link 'Test article'

      expect {
        expect(page).to have_button '削除'
        link = find_button('削除')
        click_button '削除'
      }.to change(user.articles, :count).by(-1)

      expect(page).to have_content '削除しました'
      expect(page).to_not have_content 'Test article'
      expect(current_path).to eq articles_path
    end
  end
end
