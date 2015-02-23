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
end
