require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      controller.session[:user_id] = 100500
      get :home
      expect(response).to have_http_status(:success)
    end

    it "returns http redirect" do
      get :home
      expect(response).to have_http_status(302)
    end
  end

end
