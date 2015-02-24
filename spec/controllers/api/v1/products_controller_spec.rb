require 'rails_helper'
require 'request_helpers'

RSpec.describe Api::V1::ProductsController do
  describe "GET #show" do
    before(:example) do
      @product = Fabricate(:product)
      get :show, id: @product.id
    end

    it { is_expected.to respond_with :ok }

    it "returns the product in json" do
      expect(json_response[:title]).to eq(@product.title)
    end
  end

  describe "GET #index" do
    before(:example) do
      3.times { Fabricate(:product) }
      get :index
    end

    it { is_expected.to respond_with :ok }

    it "returns a list of products in json" do
      expect(json_response[:products].size).to eq(3)
    end
  end

  fdescribe "POST #create" do
    context "success" do
      it "returns the created product" do
        user = Fabricate(:user)
        product_attributes = Fabricate.attributes_for(:product_without_user)
        api_authorization_header(user.auth_token)
        post :create, user_id: user.id, product: product_attributes

        expect(json_response[:title]).to eq(product_attributes[:title])
        expect(response).to have_http_status(:created)
      end
    end

    context "invalid data" do
      it "returns the errors" do
        user = Fabricate(:user)
        api_authorization_header(user.auth_token)
        post :create, user_id: user.id, product: { title: "Eye", price: "One dollar" }

        expect(json_response[:errors][:price]).to include("is not a number")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
