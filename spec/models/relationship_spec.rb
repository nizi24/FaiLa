require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let(:user) { FactoryBot.create(:user) }

  before do
    other_user = FactoryBot.create(:user)
    @relationship = Relationship.new(followed_id: user.id, follower_id: other_user.id)
  end

  it '有効であること' do
    expect(@relationship).to be_valid
  end

  it 'followed_idが空の時、無効であること' do
    @relationship.followed_id = nil
    expect(@relationship).to_not be_valid
  end

  it 'follower_idが空の時、無効であること' do
    @relationship.follower_id = nil
    expect(@relationship).to_not be_valid
  end
end
