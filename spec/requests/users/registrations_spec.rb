require "rails_helper"

RSpec.describe "Users::Registrations", type: :request do
  describe "GET /users/edit" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get edit_user_registration_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "200を返す" do
        get edit_user_registration_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
