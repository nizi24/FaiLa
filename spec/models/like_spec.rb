require 'rails_helper'

RSpec.describe Like, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article) }

  before do
    @like = Like.new(user_id: user.id, likeable_id: article.id, likeable_type: 'Article')
  end

  it '有効であること' do
    expect(@like).to be_valid
  end

  it 'ユーザーIDが指定されていない時、無効であること' do
    @like.user_id = nil
    expect(@like).to_not be_valid
  end

  it 'オブジェクトIdが指定されていない時、無効であること' do
    @like.likeable_id = nil
    expect(@like).to_not be_valid
  end

  it 'オブジェクトタイプが指定されていない時、無効であること' do
    @like.likeable_type = nil
    expect(@like).to_not be_valid
  end

  it 'オブジェクトのタイプとID、ユーザーIDの組み合わせはユニークであること' do
        Like.create(user_id: user.id, likeable_id: article.id, likeable_type: 'Article')
    like = Like.new(user_id: user.id, likeable_id: article.id, likeable_type: 'Article')
    expect(like).to_not be_valid
  end

end
