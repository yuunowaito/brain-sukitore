require "rails_helper"

RSpec.describe "Games", type: :request do
  let!(:game_type) { create(:game_type, name: "hiragana_calc") }

  describe "GET /games/:id" do
    it "200を返す" do
      get game_path(game_type)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /games/:id/play" do
    it "200を返す" do
      get play_game_path(game_type)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /games/answer" do
    let(:params) { { selected: "1", answer: "1" } }
    before { get play_game_path(game_type) }# session[:game_type]をセットするために先にplayにアクセス

    it "JSONを返す" do
      post answer_games_path, params: params
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("application/json")
    end

    it "correct・score・questionキーを含む" do
      post answer_games_path, params: params
      json = JSON.parse(response.body)
      expect(json).to include("correct", "score", "question")
    end
  end

  describe "GET /games/result" do
    context "ログイン済みの場合" do
      let(:user) { create(:user) }

      before do
        sign_in user
        get play_game_path(game_type) # session[:score]を初期化
      end

      it "200を返す" do
        get result_games_path
        expect(response).to have_http_status(:ok)
      end

      it "スコアがDBに保存される" do
        expect {
          get result_games_path
        }.to change(Score, :count).by(1)
      end
    end

    context "未ログインの場合" do
      before { get play_game_path(game_type) }

      it "200を返す" do
        get result_games_path
        expect(response).to have_http_status(:ok)
      end

      it "スコアがDBに保存されない" do
        expect {
          get result_games_path
        }.not_to change(Score, :count)
      end
    end
  end

  describe "GET /games/color_grid" do
    it "200を返す" do
      sign_in create(:user)
      create(:game_type, name: "color_grid")
      get color_grid_games_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /games/color_grid_complete" do
    it "スコアが保存されJSONを返す" do
      user = create(:user)
      sign_in user
      create(:game_type, name: "color_grid")

      post color_grid_complete_games_path,
        params: { score: 3, target_count: 3 }, as: :json

      expect(response).to have_http_status(:ok)
      expect(Score.count).to eq(1)
      json = JSON.parse(response.body)
      expect(json).to have_key("next_sample")
      expect(json).to have_key("next_answer")
    end
  end
end
