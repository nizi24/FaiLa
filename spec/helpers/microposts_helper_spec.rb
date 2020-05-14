require 'rails_helper'

RSpec.describe MicropostsHelper, type: :helper do

  describe 'scan_user_name' do

    let(:micropost) { FactoryBot.create(:micropost, content: '@test1@test2@test3@test4') }

    before do
      @user1 = User.create(name: 'test1', email: 'test1@example.com', password: 'password',
                           unique_name: 'test1')
      @user2 = User.create(name: 'test2', email: 'test2@example.com', password: 'password',
                           unique_name: 'test2')
      @user3 = User.create(name: 'test3', email: 'test3@example.com', password: 'password',
                           unique_name: 'test3')

      scan_user_name(micropost)
    end

    it 'ユーザー名をスキャンして、ユーザーを捕捉し、配列にして返すこと' do
      expect(@received_users).to eq [@user1, @user2, @user3]
    end

    it 'ユーザー名をスキャンして、ユーザーが存在した場合、つぶやきからユーザー名を一時的に削除すること' do
      expect(micropost.content).to eq '@test4'
    end
  end
end
