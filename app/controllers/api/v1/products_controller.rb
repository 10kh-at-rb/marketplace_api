class Api::V1::ProductsController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, only: :create
  before_action :authorize!, only: :create

  def show
    respond_with Product.friendly.find(params[:id])
  end

  def index
    if params[:product_ids].present?
      products = Product.find(params[:product_ids])
    else
      products = Product.all
    end
    respond_with products, root: "data"
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
