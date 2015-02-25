class Api::V1::OrdersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, :authorize!

  def index
    respond_with current_user.orders, root: "data"
  end
end
