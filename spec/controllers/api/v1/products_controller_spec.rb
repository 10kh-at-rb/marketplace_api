require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::ProductsController do
  describe "GET #show" do
    it "returns the product in json" do
      product = Fabricate(:product)
      get :show, id: product.slug

      expect(json_response[:data][:title]).to eq(product.title)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #index" do
    it "returns a list of products in json" do
      3.times { Fabricate(:product) }
      get :index

      expect(json_response[:data].size).to eq(3)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    context "success" do
      it "returns the created product" do
        user = Fabricate(:user)
        product_attributes = Fabricate.attributes_for(:product_without_user)
        api_authorization_header(user.auth_token)
        post :create, user_id: user.name, product: product_attributes

        expect(json_response[:data][:title]).to eq(product_attributes[:title])
        expect(response).to have_http_status(:created)
      end
    end

    context "invalid data" do
      it "returns the errors" do
        user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        post :create, user_id: user.name, product: { title: "Eye", price: "Ha'penny" }

        expect(json_response[:errors][:price]).to include("is not a number")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "unauthorized" do
      it "returns an unauthorized error" do
        user = Fabricate(:user)
        another_user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        post :create, user_id: another_user.name,
          product: { title: "Moon", price: 563463634634634.42 }

        expect(json_response[:errors]).to include("Not authorized")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
