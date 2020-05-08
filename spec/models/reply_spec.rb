require 'rails_helper'

RSpec.describe Reply, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost) }

  before do
    other_user = FactoryBot.create(:user)
    reply = FactoryBot.create(:micropost)
    @reply_to_user = Reply.new(sended_user_id: user.id,
                               received_user_id: other_user.id,
                               sended_micropost_id: reply.id)

    @reply_to_micropost = Reply.new(sended_user_id: user.id,
                                    received_user_id: other_user.id,
                                    sended_micropost_id: reply.id,
                                    received_micropost_id: micropost.id)
  end

  it 'ユーザーへの返信が有効であること' do
    expect(@reply_to_user).to be_valid
  end

  it 'つぶやきへの返信が有効であること' do
    expect(@reply_to_micropost).to be_valid
  end

  it '送信するユーザーが指定されていない時、無効であること' do
    @reply_to_micropost.sended_user_id = nil
    expect(@reply_to_micropost).to_not be_valid
  end

  it '返信先のユーザーが指定されていない時、無効であること' do
    @reply_to_micropost.received_user_id = nil
    expect(@reply_to_micropost).to_not be_valid
  end

  it '送信するつぶやきが指定されていない時、無効であること' do
    @reply_to_micropost.sended_micropost_id = nil
    expect(@reply_to_micropost).to_not be_valid
  end

end
