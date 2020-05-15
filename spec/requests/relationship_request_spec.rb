require 'rails_helper'

RSpec.describe "Relationships", type: :request do

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe '#create' do

    context 'ログインしたユーザーとして' do
      it 'フォローに成功すること' do
        log_in user
        expect {
          post relationships_path, params: { followed_id: other_user.id}
        }.to change(other_user.followers, :count).by(1)
      end

      it 'フォローされたとき通知が送信されること' do
        log_in user
        expect {
          post relationships_path, params: { followed_id: other_user.id}
        }.to change(other_user.notices, :count).by(1)
      end

      it 'フォローしたユーザーの設定がfalseの時、通知は作られないこと' do
        other_user.setting.update(notice_of_follow: false)

        log_in user
        expect {
          post relationships_path, params: { followed_id: other_user.id}
        }.to_not change(other_user.notices, :count)
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        post relationships_path, params: { followed_id: user.id }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe '#destroy' do
    context 'ログインしたユーザーとして' do
      it 'フォロー解除に成功すること' do
        log_in user
        user.follow(other_user)
        relationship = user.active_relationships.find_by(followed_id: other_user.id)
        expect {
          delete relationship_path(relationship)
        }.to change(other_user.followers, :count).by(-1)
      end
    end

    context 'ゲストとして' do
      it 'ログインページにリダイレクトすること' do
        user.follow(other_user)
        relationship = user.active_relationships.find_by(followed_id: other_user.id)
        expect {
          delete relationship_path(relationship)
        }.to_not change(other_user.followers, :count)
      end
    end
  end
end
