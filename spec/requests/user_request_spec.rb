require 'rails_helper'
include SessionsHelper

RSpec.describe "Users", type: :request do
  describe '#new' do
    context 'ゲストとして' do
      it '200レスポンスを返すこと' do
        get new_user_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#update' do
    context '認可されたユーザーの時' do
      let(:user) { FactoryBot.create(:user) }

      it '編集に成功すること' do
        log_in user
        user_params = FactoryBot.attributes_for(:user, name: 'Tester')
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq 'Tester'
      end
    end

    context 'ゲストとして' do
      let(:user) { FactoryBot.create(:user) }

      it 'ログインページにリダイレクトすること' do
        user_params = FactoryBot.attributes_for(:user, name: 'Tester')
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to '/login'
      end
    end
  end
end
