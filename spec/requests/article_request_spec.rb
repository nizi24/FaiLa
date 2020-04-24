require 'rails_helper'

RSpec.describe "Articles", type: :request do
let(:user) { FactoryBot.create(:user) }

  describe '#new' do

    context 'ログインしたユーザーの時' do
      it '200レスポンスを返すこと' do
        log_in user
        get new_article_path
        expect(response).to have_http_status(200)
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        get new_article_path
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#create' do
    context 'ログインしたユーザーの時' do
      it '記事投稿に成功すること' do
        log_in user
        post articles_path, params: { article: { title: 'test', content: 'Testing article functionality'} }
        expect(user.articles).to_not be_nil
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        post articles_path, params: { article: { title: 'test', content: 'Testing article functionality'} }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do

    context '認可されたユーザーの時' do
      it '記事削除に成功すること' do
        article = FactoryBot.create(:article, user: user)

        log_in user
        expect{
          delete article_path(article), params: { id: article.id }
        }.to change(user.articles, :count).by(-1)
      end
    end

    context '認可されていないユーザーの時' do
      it '記事削除に失敗すること' do
        other_user = FactoryBot.create(:user)
        article = FactoryBot.create(:article, user: other_user)

        log_in user
        expect{
          delete article_path(article), params: { id: article.id }
        }.to_not change(Article, :count)
      end
    end

      it 'ダッシュボードにリダイレクトすること' do
        other_user = FactoryBot.create(:user)
        article = FactoryBot.create(:article, user: other_user)

        log_in user
        delete article_path(article), params: { id: article.id }
        expect(response).to redirect_to root_url
      end

    context 'ゲストとして' do
      it '記事を削除できないこと' do
        article = FactoryBot.create(:article, user: user)
        expect{
          delete article_path(article), params: { id: article.id }
        }.to_not change(Article, :count)
      end

      it 'ログインページにリダイレクトすること' do
        article = FactoryBot.create(:article, user: user)
        delete article_path(article), params: { id: article.id }
        expect(response).to redirect_to login_url
      end
    end
  end
end
