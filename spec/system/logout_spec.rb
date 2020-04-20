require 'rails_helper'

RSpec.describe "Logouts", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  it 'ユーザーはログアウトに成功する' do
    log_in_as user
    expect(page).to have_content 'ログインに成功しました'

    click_link 'アカウント'
    click_button 'ログアウト'

    expect(current_path).to eq login_path
    expect(page).to have_css 'div.alert-info'
    expect(page).to have_content 'ログアウトしました'
    expect(page).to_not have_content 'アカウント'
    expect(page).to have_content 'ログイン'
  end
end
