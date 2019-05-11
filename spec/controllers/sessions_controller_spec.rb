require "rails_helper"

RSpec.describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    context "with valid credentials" do
      let(:handle) { "good_captain" }
      let(:password) { "good_password!" }
      let!(:user) { User.create!(handle: handle, password: password) }

      it "returns http redirect" do
        post :create, params: { session: { handle: handle, password: password } }
        expect(response).to have_http_status(302)
      end
    end

    context "with invalid credentials" do
      context "when handle is not in database" do
        it "returns http unprocessable_entity" do
          post :create, params: { session: { handle: "handle", password: "password" } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "when handle is okay" do
        let(:handle) { "forgetful_captain" }
        let(:password) { "forgotten_password!" }
        let!(:user) { User.create!(handle: handle, password: password) }

        context "password is wrong" do
          it "returns http unprocessable_entity" do
            post :create, params: { session: { handle: handle, password: "gibberish_password" } }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
    end
  end

  describe "DELETE #destroy" do
    it "returns http redirect" do
      controller.login!(100500)
      delete :destroy
      expect(response).to have_http_status(302)
    end
  end

end
