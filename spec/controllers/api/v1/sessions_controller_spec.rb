require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::SessionsController do
  include Devise::TestHelpers

  describe "POST #create" do
    let(:user) { Fabricate(:user, password: "foobarfoo",
                           password_confirmation: "foobarfoo") }

    context "correct credentials" do
      it "returns the logged in user" do
        post :create, session: { email: user.email, password: "foobarfoo" }
        user.reload
        expect(json_response[:data][:auth_token]).to eq(user.auth_token)
        expect(response).to have_http_status(:ok)
      end
    end

    context "incorrect credentials" do
      it "returns json with errors" do
        post :create, session: { email: user.email, password: "invalid_password" }
        expect(json_response[:errors]).to eq("Invalid email or password")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "incomplete credentials" do
      it "returns json with errors" do
        post :create, session: { email: user.email, password: "" }
        expect(json_response[:errors]).to eq("Must provide email and password")
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "DELETE #destroy" do
    it "generates new auth token" do
      user = Fabricate(:user)
      old_auth_token = user.auth_token
      sign_in user
      delete :destroy, id: old_auth_token

      expect(user.reload.auth_token).not_to eq(old_auth_token)
      expect(response).to have_http_status(:no_content)
    end
  end
end
