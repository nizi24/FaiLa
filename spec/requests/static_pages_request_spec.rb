require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /homes" do
    it "200レスポンスを返すこと" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe '#search' do
    context 'ゲストとして' do
      it "200レスポンスを返すこと" do
        get search_path, params: { search: '' }
        expect(response).to have_http_status(200)
      end
    end
  end
end
