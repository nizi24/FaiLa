require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe '#create' do
    context 'remember_meを使用してログインするとき' do
      let(:user) { FactoryBot.create(:user) }

      it 'クッキーを記憶していること' do
        post login_path, params: { session: { email: user.email, password: user.password, remember_me: '1'} }
        expect(response.cookies['remember_token']).to_not eq nil
      end
    end

    context 'remember_meを使用しないでログインするとき' do
      let(:user) { FactoryBot.create(:user) }

      it 'クッキーを記憶しないこと' do
        post login_path, params: { session: { email: user.email, password: user.password, remember_me: '1'} }
        delete logout_path

        post login_path, params: { session: { email: user.email, password: user.password, remember_me: '0'} }
        expect(response.cookies['remember_token']).to eq nil
      end
    end

    describe '#destroy' do
      context 'remember_meを使用してログインし、ログアウトするとき' do
        let(:user) { FactoryBot.create(:user) }

        it 'クッキーを忘れること' do
          post login_path, params: { session: { email: user.email, password: user.password, remember_me: '1'} }
          delete logout_path
          expect(response.cookies['remember_token']).to eq nil
        end

        it "logs in with valid information followed by logout" do
          log_in(user)     # spec/support/utilities.rbに定義
          expect(response).to redirect_to user_path(user)

          # ログアウトする
          delete logout_path
          expect(response).to redirect_to root_path
          expect(session[:user_id]).to eq nil

          # 2番目のウィンドウでログアウトする
          delete logout_path
          expect(response).to redirect_to root_path
          expect(session[:user_id]).to eq nil
        end
      end
    end
  end
end
