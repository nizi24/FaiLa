require 'rails_helper'

RSpec.describe "Notices", js: true, type: :system do

  before do
    driven_by :selenium_chrome_headless
  end

  let(:user) { FactoryBot.create(:user, unique_name: 'test0') }
  let(:other_user) { FactoryBot.create(:user, unique_name: 'test1')}
  let(:article) { FactoryBot.create(:article, user: user) }
  let(:micropost) { FactoryBot.create(:micropost, user: user) }

  it '自分の記事にコメントされたら通知が来ること' do
    skip '不安定で長い'
    # コメント投稿
    log_in_as other_user
    visit article_path(article)
    fill_in 'comment[content]', with: 'hello'
    within '.comment-form' do
      click_button '投稿'
    end
    log_out_as other_user

    log_in_as user
    find('.fa-bell').click
    expect(current_path).to eq user_path(user)
    expect(page).to have_content '@test1さんがあなたの記事にコメントしました'

    # アイコンリンク
    find('.notice-action-user-icon').click
    expect(current_path).to eq user_path(other_user)

    # メッセージリンク
    find('.fa-bell').click
    find('.notice-message').click
    expect(current_path).to eq article_path(article)
  end

  it '自分のつぶやきにいいねされたら通知が来ること' do
    skip '不安定で長い'
    # 他のユーザーにいいねされる
    log_in_as other_user
    visit micropost_path(micropost)
    find(:css, '.like-icon').click
    log_out_as other_user

    log_in_as user
    find('.fa-bell').click
    expect(current_path).to eq user_path(user)
    expect(page).to have_content '@test1さんがあなたの投稿にいいねしました'

    # メッセージリンク
    find('.notice-message').click
    expect(current_path).to eq micropost_path(micropost)
  end

  it 'フォローされたら通知が来ること' do
    skip '不安定で長い'
    # 他のユーザーにフォローされる
    log_in_as other_user
    visit user_path(user)
    click_button 'フォロー'
    log_out_as other_user

    log_in_as user
    find('.fa-bell').click
    expect(current_path).to eq user_path(user)
    expect(page).to have_content '@test1さんがあなたをフォローしました'

    # メッセージリンク
    find('.notice-message').click
    expect(current_path).to eq user_path(other_user)
  end

  it '自分宛てにリプライを受け取ったら通知が来ること' do
    skip '不安定で長い'
    # 他のユーザーにリプライを送られる
    log_in_as other_user
    click_link '投稿する', match: :first
    find('div.micropost-select').click
    fill_in 'micropost[content]', with: '@test0 hi'
    within ".micropost-modal" do
      click_button '投稿'
    end
    log_out_as other_user

    log_in_as user
    find('.fa-bell').click
    expect(current_path).to eq user_path(user)
    expect(page).to have_content '@test0 hi'

    # メッセージリンク
    find('.notice-message').click
    expect(current_path).to_not user_path(user)
  end
end
