require 'rails_helper'


RSpec.describe "Users", type: :request do

  let(:user) { FactoryBot.create(:user) }

  describe '#new' do

    context 'ゲストとして' do
      it '200レスポンスを返すこと' do
        get new_user_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#show' do

    context 'ゲストとして' do
      it '200レスポンスを返すこと' do
        get user_path(user)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#edit' do

    context '認可されたユーザーの時' do
      it '200レスポンスを返すこと' do
        log_in user
        get edit_user_path(user)
        expect(response).to have_http_status(200)
      end
    end

    context '認可されていないユーザーの時' do
      it 'トップページにリダイレクトすること' do
        other_user = FactoryBot.create(:user)
        log_in other_user
        get edit_user_path(user)
        expect(response).to redirect_to root_url
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        get edit_user_path(user)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#update' do

    context '認可されたユーザーの時' do
      it '編集に成功すること' do
        user_params = FactoryBot.attributes_for(:user, name: 'Tester')
        log_in user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq 'Tester'
      end
    end

    context '認可されていないユーザーの時' do
      it 'トップページにリダイレクトすること' do
        user_params = FactoryBot.attributes_for(:user, name: 'Tester')
        other_user = FactoryBot.create(:user)
        log_in other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to root_url
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        user_params = FactoryBot.attributes_for(:user, name: 'Tester')
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#followers' do
    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        get followers_user_path(user)
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#notices_check' do
    context '認可されたユーザーの時' do
      it 'すべてのcheckedをtrueに変えること' do
        log_in user
        notice1 = FactoryBot.create(:notification, received_user: user,
                                                   checked: false)
        notice2 = FactoryBot.create(:notification, received_user: user,
                                                   checked: false)
        post notices_check_user_path(user)
        expect(user.nonchecked?).to eq nil
      end
    end

    context '認可されていないユーザーの時' do
      it 'ダッシュボードにリダイレクトすること' do
        other_user = FactoryBot.create(:user)
        log_in other_user
        post notices_check_user_path(user)
        expect(response).to redirect_to root_url
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        post notices_check_user_path(user)
        expect(response).to redirect_to login_url
      end
    end
  end
end
