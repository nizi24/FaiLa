require 'rails_helper'

RSpec.describe Notification, type: :model do

  it 'messageとlinkの組み合わせがユニークであること' do
    FactoryBot.create(:notification,          message: '@test1さんがあなたの投稿にいいねしました',
                                              link: '/microposts/1')

    notice = FactoryBot.build(:notification,  message: '@test1さんがあなたの投稿にいいねしました',
                                              link: '/microposts/1')
    expect(notice).to_not be_valid
  end

  it 'messageはユニークでないこと' do
    FactoryBot.create(:notification,          message: '@test1さんがあなたの投稿にいいねしました')
    notice = FactoryBot.build(:notification,  message: '@test1さんがあなたの投稿にいいねしました')
    expect(notice).to be_valid
  end

  it 'linkはユニークでないこと' do
    FactoryBot.create(:notification,          link: '/microposts/1')
    notice = FactoryBot.build(:notification,  link: '/microposts/1')
    expect(notice).to be_valid
  end
end
