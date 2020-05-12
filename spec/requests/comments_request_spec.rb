require 'rails_helper'

RSpec.describe "Comments", type: :request do
let(:user) { FactoryBot.create(:user) }
let(:other_user) { FactoryBot.create(:user) }
let(:article) { FactoryBot.create(:article) }

  describe '#create' do

    context 'ログインしたユーザーの時' do
      context '有効な情報の時' do
        it 'コメント投稿に成功すること' do
          log_in user
          expect {
            post comments_path, params: { comment: { content: 'Interesting.', article_id: article.id} }
          }.to change(user.comments, :count).by(1)
        end

        it '記事のユーザーに通知が送信されること' do
          article = FactoryBot.create(:article, user: other_user)

          log_in user
          expect {
            post comments_path, params: { comment: { content: 'Interesting.', article_id: article.id} }
          }.to change(other_user.notices, :count).by(1)
        end

        it '自分の記事に自分でコメントしても通知は送信されないこと' do
          article = FactoryBot.create(:article, user: user)

          log_in user
          expect {
            post comments_path, params: { comment: { content: 'Interesting.', article_id: article.id} }
          }.to_not change(user.notices, :count)
        end

      context '無効な情報の時'
        it 'コメント投稿に失敗すること' do
          log_in user
          expect {
            post comments_path, params: { comment: { content: '', article_id: article.id} }
          }.to_not change(user.comments, :count)
        end
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
          post comments_path, params: { comment: { content: 'Interesting.', article_id: article.id} }
          expect(response).to redirect_to login_url
      end

      it 'コメント投稿に失敗すること' do
        expect {
          post comments_path, params: { comment: { content: 'Interesting.', article_id: article.id} }
        }.to_not change(user.comments, :count)
      end
    end
  end

  describe '#destroy' do

    context '認可されたユーザーの時' do
      it 'コメントを削除できること' do
        comment = FactoryBot.create(:comment, user: user)

        log_in user
        expect {
          delete comment_path(comment)
        }.to change(user.comments, :count).by(-1)
      end
    end

    context '認可されていないユーザーの時' do
      it 'コメントを削除できないこと' do
        other_user = FactoryBot.create(:user)
        comment = FactoryBot.create(:comment, user: other_user)

        log_in user
        expect {
          delete comment_path(comment)
        }.to_not change(other_user.comments, :count)
      end

      it 'ダッシュボードにリダイレクトすること' do
        other_user = FactoryBot.create(:user)
        comment = FactoryBot.create(:comment, user: other_user)

        log_in user
        delete comment_path(comment)
        expect(response).to redirect_to root_url
      end
    end

    context 'ゲストとして' do
      it 'コメントを削除できないこと' do
        comment = FactoryBot.create(:comment, user: user)

        expect {
          delete comment_path(comment)
        }.to_not change(user.comments, :count)
      end

      it 'ログインページにリダイレクトすること' do
        comment = FactoryBot.create(:comment, user: user)

        delete comment_path(comment)
        expect(response).to redirect_to login_url
      end
    end
  end
end
