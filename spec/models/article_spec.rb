require 'rails_helper'

RSpec.describe Article, type: :model do
  subject(:article) { FactoryBot.create(:article) }
  let(:comment) { FactoryBot.create(:comment) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:title) }

  it { is_expected.to validate_length_of(:title) }

  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to validate_length_of(:content) }


  it 'つぶやきを削除すると同時にいいねのデータも削除されること' do
    article = FactoryBot.create(:article, :have_one_like)
    expect{ article.destroy }.to change{ Like.count }.by(-1)
  end

  it '一回いいねされていること' do
    article = FactoryBot.create(:article, :have_one_like)
    expect(article.likes_total).to eq 1
  end

  it '三回いいねされていること' do
    article = FactoryBot.create(:article, :have_three_likes)
    expect(article.likes_total).to eq 3
  end

  it '五回いいねされていること' do
    article = FactoryBot.create(:article, :have_five_likes)
    expect(article.likes_total).to eq 5
  end

  it '作成日が三日前であること' do
    article = FactoryBot.build(:article, :three_days_before)
    expect(3.days.ago.all_day).to include article.created_at
  end

  it '作成日が一週間前であること' do
    article = FactoryBot.build(:article, :one_week_before)
    expect(1.week.ago.all_day).to include article.created_at
  end

  it '作成日が一か月前であること' do
    article = FactoryBot.build(:article, :one_month_before)
    expect(1.month.ago.all_day).to include article.created_at
  end

  describe 'Article.rank' do
    it '三日間のつぶやきをいいね順に返すこと' do
      have_one_like =    FactoryBot.create(:article, :have_one_like, :yesterday)
      have_three_likes = FactoryBot.create(:article, :have_three_likes, :three_days_before)
      have_five_likes =  FactoryBot.create(:article, :have_five_likes, :three_days_before)
      one_week_before =  FactoryBot.create(:article, :have_five_likes, :one_week_before)

      expect(Article.rank(3.days)).to eq [have_five_likes, have_three_likes, have_one_like]
    end

    it '一か月間のつぶやきをいいね順に返すこと' do
      have_one_like =    FactoryBot.create(:article, :have_one_like, :one_month_before)
      have_three_likes = FactoryBot.create(:article, :have_three_likes, :three_days_before)
      have_five_likes =  FactoryBot.create(:article, :have_five_likes, :one_week_before)

      expect(Article.rank(1.month)).to eq [have_five_likes, have_three_likes, have_one_like]
    end
  end

  describe 'Article.search' do
    it 'タイトルの検索結果を最新順で返すこと' do
      article1 = FactoryBot.create(:article, title: 'test1')
      article2 = FactoryBot.create(:article, title: 'test2')
      article3 = FactoryBot.create(:article, title: 'foo')

      expect(Article.search('test')).to eq [article2, article1]
    end
  end
end
