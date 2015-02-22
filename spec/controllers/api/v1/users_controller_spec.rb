require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before(:example) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    before(:example) do
      @user = Fabricate(:user)
      get :show, id: @user.id, format: :json
    end

    it { should respond_with :ok }

    it "returns user in json format" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end
  end

  describe "POST #create" do
    context "on success" do
      before(:example) do
        @user_attributes = Fabricate.attributes_for(:user)
        post :create, user: @user_attributes, format: :json
      end

      it { should respond_with :created }

      it "renders created user in json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql(@user_attributes[:email])
      end
    end

    context "on error" do
      before(:example) do
        invalid_user_attributes = { password: "12345678",
                                    password_confirmation: "12345678" }
        post :create, user: invalid_user_attributes, format: :json
      end

      it { should respond_with :unprocessable_entity }

      it "renders json with errors" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include("can't be blank")
      end
    end
  end

  describe "PUT/PATCH #update" do
    context "on success" do
      before(:example) do
        patch :update, id: Fabricate(:user).id,
                       user: { email: "user@example.io" }, format: :json
      end

      it { should respond_with :ok }

      it "renders updated user in json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql "user@example.io"
      end
    end

    context "on error" do
      before(:example) do
        patch :update, id: Fabricate(:user).id,
                       user: { email: "bademail.com" }, format: :json
      end

      it { should respond_with :unprocessable_entity }

      it "renders json with errors" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
        expect(user_response[:errors][:email]).to include("is invalid")
      end
    end
  end

  describe "DELETE #destroy" do
    before(:example) do
      @user = Fabricate(:user)
      delete :destroy, id: @user.id, format: :json
    end

    it { should respond_with :no_content }

    it "destroys the user" do
      expect { User.find(@user.id) }.to raise_error
    end
  end
end
