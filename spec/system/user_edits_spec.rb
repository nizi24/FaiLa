require 'rails_helper'
include LoginSupportWithCapybara

RSpec.describe "Edits", js: true, type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'ユーザーはプロフィールの編集に成功する' do
    user = FactoryBot.create(:user,
          name: 'Foo',
          unique_name: 'test1')

    log_in_as user
    expect(current_path).to eq user_path(user)

    click_link 'プロフィールを編集する'

    expect(page).to have_field 'user[name]', with: 'Foo'
    expect(page).to have_field 'user[unique_name]', with: 'test1'

    fill_in 'user[name]', with: 'Bar'
    fill_in 'user[unique_name]', with: 'test0'
    fill_in 'user[profile]', with: 'my profile'
    first('.btn-primary').click

    expect(current_path).to eq user_path(user)
    expect(page).to have_css 'div.alert-success'
    expect(page).to have_content '更新に成功しました'
    expect(page).to have_content 'Bar'
    expect(page).to have_content '@test0'
    expect(page).to have_content 'my profile'
  end

  it 'ユーザーは登録情報を変更する' do
    user = FactoryBot.create(:user,
           email: 'tester@example.com',
           password: 'old_password')

    log_in_as user
    visit setting_form_user_path(user)
    find('.third-select').click

    expect(page).to have_field 'user[email]', with: 'tester@example.com'
    fill_in 'user[email]', with: 'update@example.com'
    fill_in 'user[password]', with: 'new_password'
    fill_in 'user[password_confirmation]', with: 'new_password'
    page.all('.btn-primary')[2].click

    expect(user.reload.email).to eq 'update@example.com'
    expect(user.authenticate('new_password')).to be user
  end
end
