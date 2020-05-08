require 'rails_helper'

RSpec.describe "Replies", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }
  let(:micropost) { FactoryBot.create(:micropost) }

  it 'つぶやきにリプライできること' do
    log_in_as user
    visit micropost_path(micropost)

    expect {
      find('.micropost-item-reply').click
      within '.reply-form' do
        fill_in 'micropost[content]', with: 'reply test'
        click_button '投稿'
      end
    }.to change(micropost.received_replies, :count).by(1)

    expect(page).to have_content '1件の返信を表示する'
    find('.received-replies-hide').click
    expect(page).to have_content 'reply test'
  end

  it 'ユーザーにリプライできること' do
    other_user1 = FactoryBot.create(:user, unique_name: 'test1')
    other_user2 = FactoryBot.create(:user, unique_name: 'test2')
    
    log_in_as user
    click_link '投稿する', match: :first
    find('div.micropost-select').click

    expect {
      fill_in 'micropost[content]', with: '@test1 @test2 hello'
      within ".micropost-modal" do
        click_button '投稿'
      end
    }.to change(Reply, :count).by(2)

    visit articles_path
    find('.posted-select-microposts').click
    expect(page).to have_link '@test1'
    expect(page).to have_link '@test2'

    click_link '@test1'
    expect(current_path).to eq user_path(other_user1)
  end
end
