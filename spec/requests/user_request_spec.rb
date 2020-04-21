require 'rails_helper'

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
        log_in_as user
        patch :update, params: { id: user.id, user: { name: 'Tester'} }
        expect(user.reload.name).to eq 'Tester'
      end
    end
  end
end
