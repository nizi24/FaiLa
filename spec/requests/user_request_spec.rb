require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe '#new' do
    context 'ゲストとして' do
      it '200レスポンスを返すこと' do
        get new_user_path
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#edit'
    
end
