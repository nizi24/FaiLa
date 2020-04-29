require 'rails_helper'

RSpec.describe "Likes", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article) }
  let(:comment) { FactoryBot.create(:comment, article: article)}

  describe '#create' do

    context 'ログインしたユーザーの時' do
      it '記事にいいねできること' do
        log_in user
        expect {
          post article_likes_path(article), params: { article_id: article.id }
        }.to change(article.likes, :count).by(1)
      end

      it 'ユーザーは同一記事に複数いいねできないこと' do
        log_in user
        expect {
          post article_likes_path(article), params: { article_id: article.id }
          post article_likes_path(article), params: { article_id: article.id }
        }.to change(article.likes, :count).by(1)
      end

      it 'コメントにいいねできること' do
        log_in user
        expect {
          post comment_likes_path(comment), params: { comment_id: comment.id }
        }.to change(comment.likes, :count).by(1)
      end

      it 'ユーザーは同一コメントに複数いいねできないこと' do
        log_in user
        expect {
          post comment_likes_path(comment), params: { comment_id: comment.id }
          post comment_likes_path(comment), params: { comment_id: comment.id }
        }.to change(comment.likes, :count).by(1)
      end
    end

    context 'ゲストとして' do
      it '記事にいいねできないこと' do
        expect {
          post article_likes_path(article), params: { article_id: article.id }
        }.to_not change(article.likes, :count)
      end

      it 'ログインぺージにリダイレクトすること' do
        post article_likes_path(article), params: { article_id: article.id }
        expect(response).to redirect_to login_url
      end

      it 'コメントにいいねできないこと' do
        expect {
          post comment_likes_path(comment), params: { comment_id: comment.id }
        }.to_not change(comment.likes, :count)
      end

      it 'ログインページにリダイレクトすること' do
        post comment_likes_path(comment), params: { comment_id: comment.id }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do

    context '認可されたユーザーの時' do

      context '記事にいいねしていた時' do
        it '自分のいいねを解除できること' do
          article_like = FactoryBot.create(:like, :article_like, user: user, likeable: article)

          log_in user
          expect {
            delete article_like_path(article.id, article.id), params: { id: article.id, article_id: article.id }
          }.to change(user.likes, :count).by(-1)
        end
      end

      context 'コメントにいいねしていた時' do
        it '自分のいいねを解除できること' do
          comment_like = FactoryBot.create(:like, :comment_like, user: user, likeable: comment)

          log_in user
          expect {
            delete comment_like_path(comment.id, comment.id), params: { id: comment.id, comment_id: comment.id }
          }.to change(user.likes, :count).by(-1)
        end
      end
    end

    context '認可されていないユーザーの時' do

      context '記事に他のユーザーがいいねしていた時' do
        before do
          other_user = FactoryBot.create(:user)
          article_like = FactoryBot.create(:like, :article_like, user: other_user, likeable: article)
        end

        it '他のユーザーのいいねを解除できないこと' do
          log_in user
          expect {
            delete article_like_path(article.id, article.id), params: { id: article.id, article_id: article.id }
          }.to_not change(Like, :count)
        end

        it 'ダッシュボードにリダイレクトすること' do
          log_in user
          delete article_like_path(article.id, article.id), params: { id: article.id, article_id: article.id }
          expect(response).to redirect_to root_url
        end
      end

      context 'コメントに他のユーザーがいいねしていた時' do
        before do
          other_user = FactoryBot.create(:user)
          comment_like = FactoryBot.create(:like, :comment_like, user: other_user, likeable: comment)
        end

        it '他のユーザーのいいねを解除できないこと' do
          log_in user
          expect {
            delete comment_like_path(comment.id, comment.id), params: { id: comment.id, comment_id: comment.id }
          }.to_not change(Like, :count)
        end

        it 'ダッシュボードにリダイレクトすること' do
          log_in user
          delete comment_like_path(comment.id, comment.id), params: { id: comment.id, comment_id: comment.id }
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'ゲストとして' do

      context '記事に他のユーザーがいいねしていた時' do
        it '他のユーザーがいいねを解除できないこと' do
          expect {
            delete article_like_path(article.id, article.id), params: { id: article.id, article_id: article.id }
          }.to_not change(Like, :count)
        end

        it 'ログインページにリダイレクトすること' do
          delete article_like_path(article.id, article.id), params: { id: article.id, article_id: article.id }
          expect(response).to redirect_to login_url
        end
      end

      context 'コメントに他のユーザーがいいねしていた時' do
        it '他のユーザーがいいねを解除できないこと' do
          expect {
            delete comment_like_path(comment.id, comment.id), params: { id: comment.id, comment_id: comment.id }
          }.to_not change(Like, :count)
        end

        it 'ログインページにリダイレクトすること' do
          delete comment_like_path(comment.id, comment.id), params: { id: comment.id, comment_id: comment.id }
          expect(response).to redirect_to login_url
        end
      end
    end
  end
end
