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
end
