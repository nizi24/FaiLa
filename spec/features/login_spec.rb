require 'rails_helper'

RSpec.feature "Logins", type: :feature do

  scenario 'ユーザーはログインする' do
    user = FactoryBot.create(:user)

    visit root_path
    click_link 'ログイン'


    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_button 'ログイン'

    expect(current_path).to eq root_path
    expect(page).to have_content 'アカウント'
    expect(page).to_not have_content '新規登録'
  end
end
