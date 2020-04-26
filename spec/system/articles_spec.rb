require 'rails_helper'

RSpec.describe "Articles", js: true, type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'ログインしたユーザーが記事を作成するとき' do
    let(:user) { FactoryBot.create(:user) }

    it '作成に成功すること' do
      log_in_as user
      click_link '投稿する'

      expect {
        fill_in 'article[title]', with: 'Test article'
        fill_in 'article[content]', with: 'This is a test article'
        click_button '投稿'
      }.to change(user.articles, :count).by(1)

      expect(page).to have_content 'Test article'
      expect(page).to have_content user.name
    end
  end

  context 'ログインしたユーザーが記事を削除するとき' do
    let(:user) { FactoryBot.create(:user) }

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

      expect {
        expect(page).to have_button '削除'
        link = find_button('削除')
        click_button '削除'
        expect(link['data-confirm']).to eq '本当に削除しますか？'
      }.to change(user.articles, :count).by(-1)

      expect(page).to have_content '削除しました'
      expect(page).to_not have_content 'Test article'
      expect(current_path).to eq articles_path
    end
  end
end
