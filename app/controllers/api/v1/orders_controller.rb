class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, :authorize!

  def index
    orders = current_user.orders.page(params[:page]).per(params[:per_page])
    render json: orders,
      meta: { pagination: { per_page:     params[:per_page],
                            total_pages:  params[:total_pages],
                            total_objects: params[:total_objects] } },
      root: "data"
  end

  def show
    respond_with current_user.orders.find(params[:id])
  end

  def create
    if order = CreatesOrder.new(current_user).from_list(params[:order][:a_list])
      OrderMailer.send_confirmation(order).deliver_now
      respond_with order, status: :created, location: [:api, current_user, order]
    else
      render json: { errors: "Invalid product id" }, status: :unprocessable_entity
    end
  end
end
