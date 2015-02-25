class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, :authorize!

  def index
    respond_with current_user.orders, root: "data"
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.build(order_params)
    order.save
    respond_with order, status: :created, location: [:api, current_user, order]
  end

  private

  def order_params
    params.require(:order).permit(product_ids: [])
  end
end
