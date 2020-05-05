require 'rails_helper'

RSpec.describe "Microposts", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost, user: user) }


  describe '#show' do
    context 'ゲストとして' do
      it '200レスポンスを返すこと' do
        get micropost_path(micropost)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#create' do
    context 'ログインしたユーザーの時' do
      it 'つぶやきを投稿できること' do
        log_in user
        expect {
          post microposts_path, params: { micropost: { content: 'Test'} }
        }.to change(user.microposts, :count).by(1)
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        post microposts_path, params: { micropost: { content: 'Test'} }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do
    before do
      micropost
    end

    context '認可されたユーザーの時' do
      it 'つぶやきを削除できること' do
        log_in user
        expect {
          delete micropost_path(micropost)
        }.to change(user.microposts, :count).by(-1)
      end
    end

    context '認可されていないユーザーの時' do
      it 'つぶやきを削除できないこと' do
        log_in other_user
        expect {
          delete micropost_path(micropost)
        }.to_not change(user.microposts, :count)
      end

      it 'ダッシュボードにリダイレクトすること' do
        log_in other_user
        delete micropost_path(micropost)
        expect(response).to redirect_to root_url
      end
    end

    context 'ゲストとして' do
      it 'つぶやきを削除できないこと' do
        expect {
          delete micropost_path(micropost)
        }.to_not change(other_user.microposts, :count)
      end

      it 'ログインページにリダイレクトすること' do
        delete micropost_path(micropost)
        expect(response).to redirect_to login_url
      end
    end
  end
end
