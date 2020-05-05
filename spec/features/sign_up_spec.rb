require 'rails_helper'

RSpec.feature "SignUps", type: :feature do
  scenario 'ユーザーはアカウントを作成する' do
    visit root_path

    expect {
    click_link "Sign Up Now!!"
    fill_in 'user[name]', with: 'テスト'
    fill_in 'user[unique_name]', with: 'abc123_'
    fill_in 'user[email]', with: 'tester@example.com'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録'
    }.to change(User, :count).by(1)

    expect(page).to have_content 'ユーザー登録が完了しました'
    expect(page).to have_content 'アカウント'
    expect(page).to have_content 'テスト'
  end
end
