require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article) }

  context 'ログインしたユーザーがコメントを投稿するとき' do
    it '投稿に成功すること' do
      article = FactoryBot.create(:article, title: 'Test article')

      log_in_as user
      visit articles_path
      click_link 'Test article'

      expect {
        fill_in 'comment[content]', with: ''
        within '.comment-form' do
          click_button '投稿'
        end
        expect(find('#article_id', visible: false).value).to eq "#{article.id}"
      }.to_not change(user.comments, :count)

      expect(page).to have_content 'コメントできませんでした'
      expect(current_path).to eq article_path(article)

      expect {
        fill_in 'comment[content]', with: 'Interesting.'
        within '.comment-form' do
          click_button '投稿'
        end
      }.to change(user.comments, :count).by(1)

      expect(page).to have_content 'コメントしました'
      expect(current_path).to eq article_path(article)

      expect(page).to have_content user.name
      expect(page).to have_content 'Interesting.'
    end
  end

  context 'ゲストとして' do
    it 'コメント投稿フォームが表示されていないこと' do
      visit article_path(article)
      expect(page).to_not have_css '.comment-form'
    end
  end

  context 'ログインしたユーザーがコメントを削除するとき' do
    it '他のユーザーのコメントに削除ボタンがないこと' do
      other_user = FactoryBot.create(:user)
      comment = FactoryBot.create(:comment, user: other_user, article: article,
                                  content: 'Interesting.')

      log_in_as user
      visit article_path(article)
      expect(page).to have_content 'Interesting.'
      expect(page).to_not have_button '削除'
    end

    it '自分のコメントは削除に成功すること' do
      article = FactoryBot.create(:article, title: 'Test article')
      comment = FactoryBot.create(:comment, user: user, article: article,
                                  content: 'Interesting.')

      log_in_as user
      visit article_path(article)
      expect(page).to have_content 'Interesting.'

      expect {
        expect(page).to have_button '削除'
        link = find_button('削除')
        click_button '削除'
        expect(link['data-confirm']).to eq '本当に削除しますか？'
      }.to change(user.comments, :count).by(-1)

      expect(page).to have_content 'コメントを削除しました'
      expect(page).to_not have_content 'Interesting.'
      expect(current_path).to eq article_path(article)
    end
  end
end
