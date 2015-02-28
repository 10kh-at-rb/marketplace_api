class Api::V1::ProductsController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, :authorize!, only: :create

  def show
    respond_with Product.friendly.find(params[:id])
  end

  def index
    products = Product.search(params).page(params[:page]).per(params[:per_page])
    render json: products, meta: pagination(products, params[:per_page]), root: "data"
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
