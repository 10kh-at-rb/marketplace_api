class Api::V1::UsersController < ApplicationController
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end

  def create
    user = User.create(user_params)
    respond_with user, status: :created, location: [:api, user]
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, status: :ok, location: [:api, user]
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
