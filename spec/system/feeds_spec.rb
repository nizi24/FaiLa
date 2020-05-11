require 'rails_helper'

RSpec.describe "Feeds", js: true, type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  it '正しいフィードが表示されていること' do
    article = FactoryBot.create(:article, user: other_user)
    micropost = FactoryBot.create(:micropost, user: other_user)

    visit root_url
    expect(page).to_not have_content 'タイムライン'


    #フォローする
    log_in_as user
    visit user_path(other_user)
    click_on 'フォロー'
    visit root_path

    #タイムライン
    expect(page).to have_css '.timeline'
    expect(page).to have_css '.feed-all'
    first('.select-center').click
    expect(page).to have_css '.feed-articles'
    first('.select-right').click
    expect(page).to have_css '.feed-microposts'

    #トレンド(記事)
    find('.trend-select').click
    expect(page).to have_css '.trend'
    expect(page).to have_css '.article-trend'
    expect(page).to have_css '.trend-recent'
    page.all('.select-center')[1].click
    expect(page).to have_css '.trend-week'
    page.all('.select-right')[1].click
    expect(page).to have_css '.trend-month'

    #トレンド(つぶやき)
    find('.select-micropost').click
    expect(page).to have_css '.micropost-trend'

    #フィード選択の保持
    page.all('.select-left')[1].click
    find('.timeline-select').click
    expect(page).to have_css '.feed-microposts'
  end
end
