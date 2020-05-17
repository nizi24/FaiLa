require 'rails_helper'

RSpec.describe Micropost, type: :model do

  subject(:micropost) { FactoryBot.create(:micropost) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to validate_length_of(:content) }

  it 'つぶやきを削除すると同時にいいねのデータも削除されること' do
    micropost = FactoryBot.create(:micropost, :have_one_like)
    expect{ micropost.destroy }.to change{ Like.count }.by(-1)
  end

  it '一回いいねされていること' do
    micropost = FactoryBot.create(:micropost, :have_one_like)
    expect(micropost.likes_total).to eq 1
  end

  it '三回いいねされていること' do
    micropost = FactoryBot.create(:micropost, :have_three_likes)
    expect(micropost.likes_total).to eq 3
  end

  it '五回いいねされていること' do
    micropost = FactoryBot.create(:micropost, :have_five_likes)
    expect(micropost.likes_total).to eq 5
  end

  it '作成日が三日前であること' do
    micropost = FactoryBot.build(:micropost, :three_days_before)
    expect(3.days.ago.all_day).to include micropost.created_at
  end

  it '作成日が一週間前であること' do
    micropost = FactoryBot.build(:micropost, :one_week_before)
    expect(1.week.ago.all_day).to include micropost.created_at
  end

  it '作成日が一か月前であること' do
    micropost = FactoryBot.build(:micropost, :one_month_before)
    expect(1.month.ago.all_day).to include micropost.created_at
  end

  describe 'Micropost.rank' do
    it '三日間のつぶやきをいいね順に返すこと' do
      have_one_like =    FactoryBot.create(:micropost, :have_one_like, :yesterday)
      have_three_likes = FactoryBot.create(:micropost, :have_three_likes, :three_days_before)
      have_five_likes =  FactoryBot.create(:micropost, :have_five_likes, :three_days_before)
      one_week_before =  FactoryBot.create(:micropost, :have_five_likes, :one_week_before)

      expect(Micropost.rank(3.days)).to eq [have_five_likes, have_three_likes, have_one_like]
    end

    it '一か月間のつぶやきをいいね順に返すこと' do
      have_one_like =    FactoryBot.create(:micropost, :have_one_like, :one_month_before)
      have_three_likes = FactoryBot.create(:micropost, :have_three_likes, :three_days_before)
      have_five_likes =  FactoryBot.create(:micropost, :have_five_likes, :one_week_before)

      expect(Micropost.rank(1.month)).to eq [have_five_likes, have_three_likes, have_one_like]
    end
  end

  describe 'Micropost.search' do
    it '検索結果を最新順で返すこと' do
      micropost1 = FactoryBot.create(:micropost, content: '@test1 hello')
      micropost2 = FactoryBot.create(:micropost, content: 'posting test')
      micropost3 = FactoryBot.create(:micropost, content: 'foo bar')

      expect(Micropost.search('test')).to eq [micropost2, micropost1]
    end
  end
end
