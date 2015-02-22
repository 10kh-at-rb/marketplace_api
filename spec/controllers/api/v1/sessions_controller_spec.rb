require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::SessionsController do
  describe "POST #create" do
    before(:example) do
      @user = Fabricate(:user, password: "foobarfoo",
                        password_confirmation: "foobarfoo")
    end

    context "when credentials are correct" do
      before(:example) do
        post :create, session: { email: @user.email, password: "foobarfoo" }
      end

      it { is_expected.to respond_with :ok }

      it "returns the logged in user" do
        @user.reload
        expect(json_response[:auth_token]).to eq(@user.auth_token)
      end
    end

    context "when credentials are incorrect" do
      before(:example) do
        post :create, session: { email: @user.email, password: "invalid_password" }
      end

      it { is_expected.to respond_with :unprocessable_entity }

      it "returns json with errors" do
        expect(json_response[:errors]).to eq("Invalid email or password")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:example) do
      user = Fabricate(:user)
      sign_in user
      delete :destroy, id: user.auth_token
    end

    it { is_expected.to respond_with :no_content }
  end
end
