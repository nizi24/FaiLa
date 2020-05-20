require 'rails_helper'

RSpec.describe Contact, type: :model do
  subject(:contact) { FactoryBot.create(:contact) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_length_of(:email) }

  it '無効なメールアドレスは送信に成功しないこと' do
    invalid_email = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_email.each do |email|
      contact = FactoryBot.build(:contact, email: email)
      expect(contact).to_not be_valid
    end
  end

  it 'メールアドレスは入力しなくても送信できること' do
    contact = FactoryBot.build(:contact, email: '')
    expect(contact).to be_valid
  end

  it { is_expected.to validate_presence_of(:message) }
end
