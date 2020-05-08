require 'rails_helper'

RSpec.describe RepliesHelper, type: :helper do

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe 'max_likes_reply' do

    it '最もいいねの多いリプライを返すこと' do
      micropost = FactoryBot.create(:micropost, user: other_user)
      have_one_likes_reply   = FactoryBot.create(:micropost, :have_one_likes,   user: user)
      have_three_likes_reply = FactoryBot.create(:micropost, :have_three_likes, user: user)
      have_five_likes_reply  = FactoryBot.create(:micropost, :have_five_likes,  user: user)

      reply_one = Reply.create(sended_user_id:        user.id,
                               received_user_id:      other_user.id,
                               sended_micropost_id:   have_one_likes_reply.id,
                               received_micropost_id: micropost.id)
      reply_three = Reply.create(sended_user_id:        user.id,
                                 received_user_id:      other_user.id,
                                 sended_micropost_id:   have_three_likes_reply.id,
                                 received_micropost_id: micropost.id)
      reply_five = Reply.create(sended_user_id:        user.id,
                                received_user_id:      other_user.id,
                                sended_micropost_id:   have_five_likes_reply.id,
                                received_micropost_id: micropost.id)

      expect(max_likes_reply(micropost)).to eq have_five_likes_reply
    end


  end
end
