class Api::V1::UsersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token!, only: [:update, :destroy]
  before_action :authorize!, only: [:update, :destroy]

  def show
    respond_with User.friendly.find(params[:id])
  end

  def create
    user = User.create(user_params)
    respond_with user, status: :created, location: [:api, user]
  end

  def update
    if current_user.update(user_params)
      render json: current_user, status: :ok, location: [:api, current_user]
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
