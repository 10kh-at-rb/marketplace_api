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


  describe "GET #show" do
    context "view current user's order" do
      it "returns the requested order" do
        current_user = Fabricate(:user_with_orders)
        api_authorization_header(current_user.auth_token)
        order = current_user.orders.sample
        order.save
        get :show, user_id: current_user.name, id: order.id

        expect(json_response[:data][:id]).to eq(order.id)
        expect(json_response[:data][:total]).to eq(order.total.to_s)
        expect(json_response[:data][:products].size).to eq(order.products.size)
        expect(response).to have_http_status(:ok)
      end
    end

    context "unauthenticated" do
      it "returns the unauthorized error" do
        current_user = Fabricate(:user_with_orders)
        order = current_user.orders.sample
        get :show, user_id: current_user.name, id: order.id

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "view another user's order" do
      it "returns the unauthorized error" do
        current_user = Fabricate(:user)
        another_user_order = Fabricate(:order)
        another_user = another_user_order.user
        api_authorization_header(current_user.auth_token)
        get :show, user_id: another_user.name, id: another_user_order.id

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST #create" do
    context "correct order" do
      it "returns the just user order record" do
        current_user = Fabricate(:user)
        api_authorization_header(current_user.auth_token)
        p1, p2 = Fabricate(:product), Fabricate(:product)

        expect do
          post :create, user_id: current_user.name,
                        order: { product_ids: [p1.id, p2.id] }
        end.to change(Order, :count).by(1)

        expect(json_response[:data][:id]).to be_present
        expect(response).to have_http_status(:created)
      end
    end

    context "when trying to order for another user" do
      it "returns the unauthorized error" do
        current_user, another_user = Fabricate(:user), Fabricate(:user)
        p1, p2 = Fabricate(:product), Fabricate(:product)
        api_authorization_header(current_user.auth_token)

        post :create, user_id: another_user.name,
                      order: { product_ids: [p1.id, p2.id] }

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "unauthenticated" do
      it "returns the unauthorized error" do
        current_user = Fabricate(:user)
        p1, p2 = Fabricate(:product), Fabricate(:product)

        post :create, user_id: current_user.name,
                      order: { product_ids: [p1.id, p2.id] }

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
