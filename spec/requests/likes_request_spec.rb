require 'rails_helper'

RSpec.describe "Likes", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article) }
  let(:comment) { FactoryBot.create(:comment, article: article)}
  let(:micropost) { FactoryBot.create(:micropost) }

  let(:other_user) { FactoryBot.create(:user) }
  let(:article_like) { FactoryBot.create(:article_like, user: other_user, likeable: article) }
  let(:comment_like) { FactoryBot.create(:comment_like, user: other_user, likeable: comment) }


  describe '#create' do

    context 'ログインしたユーザーの時' do
      it '記事にいいねできること' do
        log_in user
        expect {
          post likes_path, params: { likeable_id: article.id, likeable_type: 'Article' }
        }.to change(article.likes, :count).by(1)
      end

      it 'ユーザーは同一記事に複数いいねできないこと' do
        log_in user
        expect {
          post likes_path, params: { likeable_id: article.id, likeable_type: 'Article' }
          post likes_path, params: { likeable_id: article.id, likeable_type: 'Article' }
        }.to change(article.likes, :count).by(1)
      end

      it 'コメントにいいねできること' do
        log_in user
        expect {
          post likes_path, params: { likeable_id: comment.id, likeable_type: 'Comment' }
        }.to change(comment.likes, :count).by(1)
      end

      it 'ユーザーは同一コメントに複数いいねできないこと' do
        log_in user
        expect {
          post likes_path, params: { likeable_id: comment.id, likeable_type: 'Comment' }
          post likes_path, params: { likeable_id: comment.id, likeable_type: 'Comment' }
        }.to change(comment.likes, :count).by(1)
      end

      it 'つぶやきにいいねできること' do
        log_in user
        expect{
          post likes_path, params: { likeable_id: micropost.id, likeable_type: 'Micropost' }
        }.to change(micropost.likes, :count).by(1)
      end

      it 'いいねされたときに通知が送信されること' do
        micropost = FactoryBot.create(:micropost, user: other_user)

        log_in user
        expect{
          post likes_path, params: { likeable_id: micropost.id, likeable_type: 'Micropost', user_id: other_user.id }
        }.to change(other_user.notices, :count).by(1)
      end

      it '自分の投稿にいいねしても、通知が送信されないこと' do
        micropost = FactoryBot.create(:micropost, user: user)

        log_in user
        expect{
          post likes_path, params: { likeable_id: micropost.id, likeable_type: 'Micropost', user_id: user.id }
        }.to_not change(user.notices, :count)
      end
    end

    context 'ゲストとして' do
      it '記事にいいねできないこと' do
        expect {
          post likes_path, params: { likeable_id: article.id, likeable_type: 'Article' }
        }.to_not change(article.likes, :count)
      end

      it 'ログインぺージにリダイレクトすること' do
        post likes_path, params: { likeable_id: article.id, likeable_type: 'Article' }
        expect(response).to redirect_to login_url
      end

      it 'コメントにいいねできないこと' do
        expect {
          post likes_path, params: { likeable_id: comment.id, likeable_type: 'Comment' }
        }.to_not change(comment.likes, :count)
      end

      it 'ログインページにリダイレクトすること' do
        post likes_path, params: { likeable_id: comment.id, likeable_type: 'Comment' }
        expect(response).to redirect_to login_url
      end

      it 'つぶやきにいいねできないこと' do
        expect{
          post likes_path, params: { likeable_id: micropost.id, likeable_type: 'Micropost' }
        }.to_not change(micropost.likes, :count)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do

    before do
      article_like
      comment_like
    end

    context '認可されたユーザーの時' do

      context '記事にいいねしていた時' do
        it '自分のいいねを解除できること' do
          log_in other_user
          expect {
            delete like_path(article_like), params: { likeable_id: article.id, likeable_type: 'Article'}
          }.to change(other_user.likes, :count).by(-1)
        end
      end

      context 'コメントにいいねしていた時' do
        it '自分のいいねを解除できること' do
          log_in other_user
          expect {
            delete like_path(comment_like), params: { likeable_id: comment.id, likeable_type: 'Comment' }
          }.to change(other_user.likes, :count).by(-1)
        end
      end
    end

    context '認可されていないユーザーの時' do

      context '記事に他のユーザーがいいねしていた時' do

        it '他のユーザーのいいねを解除できないこと' do
          log_in user
          expect {
            delete like_path(article_like), params: { likeable_id: article.id, likeable_type: 'Article'}
          }.to_not change(Like, :count)
        end

        it 'ダッシュボードにリダイレクトすること' do
          log_in user
          delete like_path(article_like), params: { likeable_id: article.id, likeable_type: 'Article'}
          expect(response).to redirect_to root_url
        end
      end

      context 'コメントに他のユーザーがいいねしていた時' do

        it '他のユーザーのいいねを解除できないこと' do
          log_in user
          expect {
            delete like_path(comment_like), params: { likeable_id: comment.id, likeable_type: 'Comment' }
          }.to_not change(Like, :count)
        end

        it 'ダッシュボードにリダイレクトすること' do
          log_in user
          delete like_path(comment_like), params: { likeable_id: comment.id, likeable_type: 'Comment' }
          expect(response).to redirect_to root_url
        end
      end
    end

    context 'ゲストとして' do

      context '記事に他のユーザーがいいねしていた時' do
        it '他のユーザーがいいねを解除できないこと' do
          expect {
            delete like_path(article_like), params: { likeable_id: article.id, likeable_type: 'Article'}
          }.to_not change(Like, :count)
        end

        it 'ログインページにリダイレクトすること' do
          delete like_path(article_like), params: { likeable_id: article.id, likeable_type: 'Article'}
          expect(response).to redirect_to login_url
        end
      end

      context 'コメントに他のユーザーがいいねしていた時' do
        it '他のユーザーがいいねを解除できないこと' do
          expect {
            delete like_path(comment_like), params: { likeable_id: comment.id, likeable_type: 'Comment' }
          }.to_not change(Like, :count)
        end

        it 'ログインページにリダイレクトすること' do
          delete like_path(comment_like), params: { likeable_id: comment.id, likeable_type: 'Comment' }
          expect(response).to redirect_to login_url
        end
      end
    end
  end
end
