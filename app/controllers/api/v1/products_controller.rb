class Api::V1::ProductsController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, only: [:create]

  def show
    respond_with Product.find(params[:id])
  end

  def index
    respond_with Product.all
  end

  def create
    product = current_user.products.create(product_params)
    respond_with product, status: :created, location: [:api, product]
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :for_sale)
  end
end
