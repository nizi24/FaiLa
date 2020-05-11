require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user)}

  it 'ユーザーはつぶやきを投稿する' do
    log_in_as user
    click_link '投稿する', match: :first
    find('div.micropost-select').click

    expect {
      fill_in 'micropost[content]', with: 'Test now.'
      within ".micropost-modal" do
        click_button '投稿'
      end
    }.to change(user.microposts, :count).by(1)
    expect(page).to have_content '投稿しました'

    visit user_path(user)
    find('.select-right').click
    expect(page).to have_content 'Test now.'
    expect(page).to have_content user.name

  end
end
