require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::OrdersController do
  describe "GET #index" do
    context "show current user orders" do
      it "returns the orders" do
        current_user = Fabricate(:user_with_orders)
        api_authorization_header(current_user.auth_token)
        get :index, user_id: current_user.name

        expect(json_response[:data].size).to eq(current_user.orders.size)
        expect(response).to have_http_status(:ok)
      end
    end

    context "unauthenticated" do
      it "returns unauthorized error" do
        current_user = Fabricate(:user_with_orders)
        get :index, user_id: current_user.name

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "show another user orders" do
      it "returns unauthorized error" do
        current_user = Fabricate(:user_with_orders)
        another_user = Fabricate(:user_with_orders)
        api_authorization_header(current_user.auth_token)
        get :index, user_id: another_user.name

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
