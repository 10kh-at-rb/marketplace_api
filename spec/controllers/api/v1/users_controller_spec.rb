require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::UsersController do
  describe "GET #show" do
    before(:example) do
      @user = Fabricate(:user)
      get :show, id: @user.id
    end

    it { is_expected.to respond_with :ok }

    it "returns user in json format" do
      expect(json_response[:email]).to eql @user.email
    end
  end

  describe "POST #create" do
    context "success" do
      before(:example) do
        @user_attributes = Fabricate.attributes_for(:user)
        post :create, user: @user_attributes
      end

      it { is_expected.to respond_with :created }

      it "renders created user in json" do
        expect(json_response[:email]).to eql(@user_attributes[:email])
      end
    end

    context "invalid data" do
      before(:example) do
        invalid_user_attributes = { password: "12345678",
                                    password_confirmation: "12345678" }
        post :create, user: invalid_user_attributes
      end

      it { is_expected.to respond_with :unprocessable_entity }

      it "renders json with errors" do
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][:email]).to include("can't be blank")
      end
    end
  end

  describe "PUT/PATCH #update" do
    context "success" do
      before(:example) do
        user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        patch :update, id: user.id, user: { email: "user@example.io" }
      end

      it { is_expected.to respond_with :ok }

      it "renders updated user in json" do
        expect(json_response[:email]).to eql "user@example.io"
      end
    end

    context "invalid data" do
      before(:example) do
        user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        patch :update, id: user.id, user: { email: "bademail.com" }
      end

      it { is_expected.to respond_with :unprocessable_entity }

      it "renders json with errors" do
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors][:email]).to include("is invalid")
      end
    end

    context "unauthorized" do
      before(:example) do
        user = Fabricate(:user)
        api_authorization_header("invalid_auth_token")
        patch :update, id: user.id, user: { email: "user@example.io" }
      end

      it { is_expected.to respond_with :unauthorized }

      it "renders json with not authorized error" do
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors]).to include("Not authorized")
      end
    end
  end

  describe "DELETE #destroy" do
    context "success with correct user id" do
      before(:example) do
        @user = Fabricate(:user)
        api_authorization_header(@user.auth_token)
        delete :destroy, id: @user.id
      end

      it { is_expected.to respond_with :no_content }

      it "destroys the current user" do
        expect { User.find(@user.id) }.to raise_error
      end
    end

    fcontext "success with incorrect user id" do
      before(:example) do
        @user = Fabricate(:user)
        @another_user = Fabricate(:user)
        api_authorization_header(@user.auth_token)
        delete :destroy, id: @another_user.id
      end

      it { is_expected.to respond_with :no_content }

      it "destroys the current user" do
        expect { User.find(@user.id) }.to raise_error
      end

      it "does not destroy another user" do
        expect(User.find(@another_user.id)).to eq(@another_user)
      end
    end

    context "unauthorized" do
      before(:example) do
        @user = Fabricate(:user)
        api_authorization_header("invalid_auth_token")
        delete :destroy, id: @user.id
      end

      it { is_expected.to respond_with :unauthorized }

      it "renders json with not authorized error" do
        expect(json_response).to have_key(:errors)
        expect(json_response[:errors]).to include("Not authorized")
      end
    end
  end
end
