require 'rails_helper'

RSpec.describe "SignUps", type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'ユーザーがアカウントを作成するとき' do
    it '有効な情報では成功すること' do
      visit root_path
      click_link 'メールアドレスで登録'

      expect {
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

    it '無効な情報では登録に失敗すること' do
      visit root_path
      click_link 'メールアドレスで登録'

      expect {
      fill_in 'user[name]', with: ' '
      fill_in 'user[unique_name]', with: ':/\][]'
      fill_in 'user[email]', with: 'tester@example,com'
      fill_in 'user[password]', with: 'pass'
      fill_in 'user[password_confirmation]', with: 'foo'
      click_button '登録'
    }.to_not change{ User }

      expect(page).to have_css 'div#error_explanation'
      expect(page).to have_content '名前を入力してください'
      expect(page).to have_content 'メールアドレスは不正な値です'
      expect(page).to have_content 'パスワードは6文字以上で入力してください'
      expect(page).to have_content '確認とパスワードの入力が一致しません'
    end
  end
end
