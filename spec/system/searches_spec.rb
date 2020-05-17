require 'rails_helper'

RSpec.describe "Searches", type: :system do
  before do
    driven_by :selenium_chrome_headless
  end

  it 'ユーザーはキーワードを検索する' do
    user1 = FactoryBot.create(:user, name: 'test user')
    user2 = FactoryBot.create(:user, name: 'foo user')

    article1 = FactoryBot.create(:article, title: 'test article')
    article2 = FactoryBot.create(:article, title: 'foo article')

    micropost1 = FactoryBot.create(:micropost, content: 'test micropost')
    micropost2 = FactoryBot.create(:micropost, content: 'foo micropost')

    log_in_as user1
    visit root_path
    find('.search-form').set('test')
    find('.search-form').native.send_key(:enter)

    expect(page).to have_content 'test user'
    expect(page).to have_content 'test article'
    find('.select-right').click
    expect(page).to have_content 'test micropost'
  end

  it 'ユーザーはunique_nameを検索する' do
    user1 = FactoryBot.create(:user, unique_name: 'testuser')
    user2 = FactoryBot.create(:user, unique_name: 'foouser')

    log_in_as user1
    visit root_path
    find('.search-form').set('@test')
    find('.search-form').native.send_key(:enter)

    expect(page).to have_content '@testuser'
  end
end
