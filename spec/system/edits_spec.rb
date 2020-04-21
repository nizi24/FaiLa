require 'rails_helper'

RSpec.describe "Edits", type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'ユーザーは編集に成功する',focus: true do
    user = FactoryBot.create(:user,
          name: 'Foo',
          email: 'tester@example.com')

    log_in_as user
    expect(current_path).to eq user_path(user)

    click_link 'ユーザー情報を編集する'

    expect(page).to have_field 'user[name]', 'Foo'
    expect(page).to have_field 'user[email]', 'tester@example.com'

    fill_in 'user[name]', with: 'Bar'
    fill_in 'user[email]', with: 'update@example.com'
    click_button '変更'

    expect(current_path).to eq user_path(user)
    expect(page).to have_css 'div.alert-success'
    expect(page).to have_content '更新に成功しました'
    expect(page).to have_content 'Bar'
    expect(user.reload.email).to eq 'update@example.com'
  end
end
