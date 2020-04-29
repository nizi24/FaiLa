require 'rails_helper'

RSpec.describe "Follows", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:user) { FactoryBot.create(:user) }

  it 'ユーザーは他のユーザーをフォローする' do
    other_user = FactoryBot.create(:user)

    log_in_as user
    visit user_path(other_user)
    expect(page).to have_link '0'

    expect {
      click_button 'フォロー'
      expect(page).to have_link '1'
    }.to change(other_user.followers, :count).by(1)

    click_link '1'
    expect(page).to have_link user.name

    expect {
      click_button 'フォロー解除'
      expect(page).to have_link '0'
    }.to change(other_user.followers, :count).by(-1)

    click_link '0'
    expect(page).to_not have_link user.name
  end
end
