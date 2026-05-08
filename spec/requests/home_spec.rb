require "rails_helper"

RSpec.describe "Home", type: :request do
  let!(:game_type) { create(:game_type, name: "hiragana_calc") }

  describe "GET /" do
    it "200を返す" do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end
end
