require 'rails_helper'

RSpec.describe Micropost, type: :model do

  subject(:micropost) { FactoryBot.create(:micropost) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to validate_length_of(:content) }
end
