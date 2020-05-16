require 'rails_helper'

RSpec.describe "Articles", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article) }

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

  describe '#edit' do
    context '認可されたユーザーの時' do
      it '200レスポンスを返すこと' do
        article = FactoryBot.create(:article, user: user)

        log_in user
        get edit_article_path(article)
        expect(response).to have_http_status(200)
      end
    end

    context '認可されていないユーザーの時' do
      it 'ダッシュボードにリダイレクトすること' do
        article = FactoryBot.create(:article, user: user)

        log_in other_user
        get edit_article_path(article)
        expect(response).to redirect_to root_url
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        get edit_article_path(article)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#update' do
    context '認可されたユーザーの時' do
      it '編集に成功すること' do
        article = FactoryBot.create(:article, user: user,
                                    content: 'Testing article functionality' )

        log_in user
        patch article_path(article), params: { article: { content: 'update article functionality' } }
        expect(article.reload.content).to eq 'update article functionality'
      end
    end

    context '認可されていないユーザーの時' do
      it 'ダッシュボードにリダイレクトすること' do
        article = FactoryBot.create(:article, user: user)

        log_in other_user
        patch article_path(article)
        expect(response).to redirect_to root_url
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        patch article_path(article)
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
          delete article_path(article)
        }.to change(user.articles, :count).by(-1)
      end
    end

    context '認可されていないユーザーの時' do
      it '記事削除に失敗すること' do
        article = FactoryBot.create(:article, user: other_user)

        log_in user
        expect{
          delete article_path(article)
        }.to_not change(Article, :count)
      end
    end

      it 'ダッシュボードにリダイレクトすること' do
        article = FactoryBot.create(:article, user: other_user)

        log_in user
        delete article_path(article), params: { id: article.id }
        expect(response).to redirect_to root_url
      end

    context 'ゲストとして' do
      it '記事を削除できないこと' do
        article = FactoryBot.create(:article)
        expect{
          delete article_path(article)
        }.to_not change(Article, :count)
      end

      it 'ログインページにリダイレクトすること' do
        delete article_path(article)
        expect(response).to redirect_to login_url
      end
    end
  end
end
