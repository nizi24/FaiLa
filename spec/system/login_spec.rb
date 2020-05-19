require 'rails_helper'

RSpec.describe "Logins", type: :system do
  before do
    driven_by(:rack_test)
  end

  context '入力に一致するアカウントが存在する時' do
    it 'ユーザーはログインする' do
      user = FactoryBot.create(:user)

      visit root_path
      click_link 'ログイン'


      fill_in 'session[email]', with: user.email
      fill_in 'session[password]', with: user.password
      click_button 'ログイン'

      expect(current_path).to eq root_path
      expect(page).to have_css 'div.alert-success'
      expect(page).to have_content 'ログインに成功しました'
      expect(page).to have_content 'アカウント'
      expect(page).to_not have_content '新規登録'
    end
  end

  context '入力に一致するアカウントが存在しない時' do
    it 'ユーザーはログインに失敗する' do
      visit root_path
      click_link 'ログイン'


      fill_in 'session[email]', with: 'foo@example.com'
      fill_in 'session[password]', with: 'invalid_password'
      click_button 'ログイン'

      expect(current_path).to eq login_path
      expect(page).to have_css 'div.alert-danger'
      expect(page).to have_content 'ログインに失敗しました'
      expect(page).to_not have_content 'アカウント'
      expect(page).to have_content '新規登録'
    end
  end
end
