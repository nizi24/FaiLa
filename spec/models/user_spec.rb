require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryBot.create(:user) }
  let(:article) { FactoryBot.create(:article) }
  let(:comment) { FactoryBot.create(:comment) }
  let(:article_like) { FactoryBot.create(:like, :article_like, user: user, likeable: article)}
  let(:comment_like) { FactoryBot.create(:like, :comment_like, user: user, likeable: comment)}

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to validate_length_of(:name) }

  it { is_expected.to validate_presence_of(:unique_name) }

  it { is_expected.to validate_length_of(:unique_name) }

  it 'ユーザー名はユニークであること' do
    FactoryBot.create(:user, unique_name: 'abc123_')
    user = FactoryBot.build(:user, unique_name: 'ABC123_')
    expect(user).to_not be_valid
  end

  it '無効なユーザー名では登録に成功しないこと' do
    invalid_unique_name = %w[123-~@ 123:;{} 123?<>]
    invalid_unique_name.each do |name|
      user = FactoryBot.build(:user, unique_name: name)
      expect(user).to_not be_valid
    end
  end

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

  describe '#already_liked?' do
    context '対象を既にいいねしている時' do
      it 'trueを返すこと' do
        article_like
        expect(user.already_liked?(article)).to be true
        comment_like
        expect(user.already_liked?(comment)).to be true
      end
    end

    context '対象をいいねしていない時' do
      it 'falseを返すこと' do
        expect(user.already_liked?(article)).to be false
        expect(user.already_liked?(comment)).to be false
      end
    end
  end

  describe '#following?' do
    context '対象をfollowした時' do
      it 'trueを返すこと' do
        other_user = FactoryBot.create(:user)
        expect(user.following?(other_user)).to be false
        user.follow(other_user)
        expect(user.following?(other_user)).to be true
      end

      it 'other_userのフォロワーにuserが存在すること' do
        other_user = FactoryBot.create(:user)
        user.follow(other_user)
        expect(other_user.followers.include?(user)).to be true
      end
    end

    context '対象をunfollowした時' do
      it 'falseを返すこと' do
        other_user = FactoryBot.create(:user)
        user.follow(other_user)
        expect(user.following?(other_user)).to be true
        user.unfollow(other_user)
        expect(user.following?(other_user)).to be false
      end
    end
  end
end
