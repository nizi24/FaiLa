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

      it 'つぶやきにリプライできること' do
        log_in user
        expect {
          post microposts_path, params: { micropost: { content: 'Test'},
                                          received_micropost_id: micropost.id,
                                          received_user_id:      micropost.user.id}
        }.to change(micropost.received_replies, :count).by(1)
      end

      it 'つぶやきに返信しつつ、他のユーザーにリプライできること' do
        other_user = FactoryBot.create(:user, unique_name: 'test0')
        log_in user
        expect {
          post microposts_path, params: { micropost: { content: '@test0 Test'},
                                          received_micropost_id: micropost.id,
                                          received_user_id:      micropost.user.id}
        }.to change(Reply, :count).by(2)
      end

      it 'つぶやきにリプライされたときに通知が送信されること' do
        micropost = FactoryBot.create(:micropost, user: other_user)

        log_in user
        expect {
          post microposts_path, params: { micropost: { content: 'Test'},
                                          received_micropost_id: micropost.id,
                                          received_user_id:      micropost.user.id}
        }.to change(other_user.notices, :count).by(1)
      end

      it '返信先のユーザーの設定がfalseの時は通知は作られないこと' do
        micropost = FactoryBot.create(:micropost, user: other_user)
        other_user.setting.update(notice_of_reply: false)

        log_in user
        expect {
          post microposts_path, params: { micropost: { content: 'Test'},
                                          received_micropost_id: micropost.id,
                                          received_user_id:      micropost.user.id}
        }.to_not change(other_user.notices, :count)
      end
    end

    it 'ユーザーにリプライできること' do
      other_user = FactoryBot.create(:user, unique_name: 'test1')

      log_in user
      expect {
        post microposts_path, params: { micropost: { content: '@test1 hello'} }
      }.to change(other_user.received_replies, :count).by(1)
    end

    it 'ユーザーにリプライされたときに通知が送信されること' do
      other_user = FactoryBot.create(:user, unique_name: 'test1')

      log_in user
      expect {
        post microposts_path, params: { micropost: { content: '@test1 hello'} }
      }.to change(other_user.notices, :count).by(1)
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

      it 'つぶやきを削除したとき、同時にリプライの関係性も削除されること' do
        log_in user
        post microposts_path, params: { micropost: { content: 'Test'},
                                        received_micropost_id: micropost.id,
                                        received_user_id:      micropost.user.id}
        expect {
          delete micropost_path(micropost)
        }.to change(Reply, :count).by(-1)
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
