require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  before(:example) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    before(:example) do
      @user = Fabricate(:user)
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with :ok }
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:example) do
        @user_attributes = Fabricate.attributes_for(:user)
        post :create, { user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql(@user_attributes[:email])
      end

      it { should respond_with :created }
    end

    context "when is not created" do
      before(:example) do
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }, format: :json
        @user_response = JSON.parse(response.body, symbolize_names: true)
      end

      it "renders json with errors" do
        expect(@user_response).to have_key(:errors)
        expect(@user_response[:errors][:email]).to include("can't be blank")
      end

      it { should respond_with :unprocessable_entity }
    end
  end
end
