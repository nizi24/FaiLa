require 'rails_helper'

RSpec.describe Article, type: :model do
  subject(:article) { FactoryBot.create(:article) }
  let(:comment) { FactoryBot.create(:comment) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:title) }

  it { is_expected.to validate_length_of(:title) }

  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to validate_length_of(:content) }

  # it { is_expected.to belong_to(:user) }
  #
  # it { is_expected.to have_many(:comment) }
end
