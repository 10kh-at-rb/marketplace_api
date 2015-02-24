require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::UsersController do
  describe "GET #show" do
    it "returns user in json format" do
      user = Fabricate(:user)
      get :show, id: user.name

      expect(json_response[:data][:name]).to eq(user.name)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "success" do
      it "renders created user in json" do
        attributes = Fabricate.attributes_for(:user)
        post :create, user: attributes

        expect(json_response[:data][:name]).to eq(attributes[:name])
        expect(response).to have_http_status(:created)
      end
    end

    context "invalid data" do
      it "renders json with errors" do
        invalid_attributes = { password: "12345678",
                               password_confirmation: "12345678" }
        post :create, user: invalid_attributes

        expect(json_response[:errors][:email]).to include("can't be blank")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT/PATCH #update" do
    context "success" do
      it "renders updated user in json" do
        user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        patch :update, id: user.name, user: { email: "user@example.io" }

        expect(json_response[:data][:email]).to eq("user@example.io")
        expect(response).to have_http_status(:ok)
      end
    end

    context "invalid data" do
      it "renders json with errors" do
        user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        patch :update, id: user.name, user: { email: "bademail.com" }

        expect(json_response[:errors][:email]).to include("is invalid")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "invalid auth token" do
      it "renders json with unauthorized error" do
        user = Fabricate(:user)
        api_authorization_header("invalid_auth_token")
        patch :update, id: user.name, user: { email: "user@example.io" }

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "trying to update other users" do
      it "renders json with unauthorized error" do
        user = Fabricate(:user)
        other_user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        patch :update, id: other_user.name, user: { email: "user@example.io" }

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE #destroy" do
    context "success" do
      it "destroys the current user" do
        user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        delete :destroy, id: user.name

        expect { User.find(user.id) }.to raise_error
        expect(response).to have_http_status(:no_content)
      end
    end

    context "unauthorized" do
      it "renders json with unauthorized error" do
        user = Fabricate(:user)
        another_user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        delete :destroy, id: another_user.name

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "invalid token" do
      it "renders json with unauthorized error" do
        user = Fabricate(:user)
        api_authorization_header("invalid_auth_token")
        delete :destroy, id: user.name

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
