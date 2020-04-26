require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:comment) { FactoryBot.create(:comment) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_length_of(:name) }

  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_length_of(:email) }

  it 'メールアドレスはユニークであること' do
    FactoryBot.create(:user, email: 'foo@example.com')
    user = FactoryBot.build(:user, email: 'foo@example.com')
    expect(user).to_not be_valid
  end

  it 'メールアドレスは大文字と小文字を区別しないこと' do
    FactoryBot.create(:user, email: 'bar@example.com')
    user = FactoryBot.build(:user, email: 'BAR@EXAMPLE.COM')
    expect(user).to_not be_valid
  end

  it '無効なメールアドレスは登録に成功しないこと' do
    invalid_email = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_email.each do |email|
      user = FactoryBot.build(:user, email: email)
      expect(user).to_not be_valid
    end
  end

  it { is_expected.to have_secure_password }

  it { is_expected.to validate_length_of :password }

  context 'パスワードが空の時' do
    it '無効な状態であること' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to_not be_valid
    end
  end

  context 'remember_digestがnilのとき' do
    it 'authenticated? は false を返すこと' do
      expect(user.authenticated?('')).to eq false
    end
  end

end
