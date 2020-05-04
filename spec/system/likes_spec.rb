require 'rails_helper'

RSpec.describe "Likes", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article) }
  let(:comment) { FactoryBot.create(:comment, article: article)}

  context 'ログインしたユーザーの時' do
    it '記事にいいねできること' do
      log_in_as user
      visit article_path(article)
      expect(page).to have_content '0'

      expect{
        expect {
          expect(page).to have_css '.far'
          find(:css, '.like-icon').click
        }.to change(user.likes, :count).by(1)
      }.to change(article.likes, :count).by(1)
      expect(page).to have_content '1'

      expect {
        expect {
          expect(page).to have_css '.fas'
          find(:css, '.like-icon').click
        }.to change(user.likes, :count).by(-1)
      }.to change(article.likes, :count).by(-1)
      expect(page).to have_content '0'

    end

    it 'コメントにいいねできること' do
      article = FactoryBot.create(:article)
      comment = FactoryBot.create(:comment, user: user, article: article)

      log_in_as user
      visit article_path(article)
      expect(page).to have_content '0'

      expect{
        expect {
          expect(page).to have_css '.far'
          find(:css, '.comment-like').click
        }.to change(user.likes, :count).by(1)
      }.to change(comment.likes, :count).by(1)
      expect(page).to have_content '1'

      expect {
        expect {
          expect(page).to have_css '.fas'
          find(:css, '.comment-like').click
        }.to change(user.likes, :count).by(-1)
      }.to change(comment.likes, :count).by(-1)
      expect(page).to have_content '0'
    end

    it 'つぶやきにいいねできること' do
      micropost = FactoryBot.create(:micropost)

      log_in_as user
      visit articles_path
      find('.posted-select-microposts').click
      expect(page).to have_content '0'

      expect{
        expect {
          expect(page).to have_css '.far'
          find(:css, '.like-icon').click
        }.to change(user.likes, :count).by(1)
      }.to change(micropost.likes, :count).by(1)
      expect(page).to have_content '1'

      expect {
        expect {
          expect(page).to have_css '.fas'
          find(:css, '.like-icon').click
        }.to change(user.likes, :count).by(-1)
      }.to change(micropost.likes, :count).by(-1)
      expect(page).to have_content '0'
    end
  end
end
