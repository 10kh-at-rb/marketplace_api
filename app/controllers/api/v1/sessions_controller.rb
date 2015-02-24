class Api::V1::SessionsController < ApplicationController
  before_action :require_email_and_password, only: :create

  def create
    user = User.find_by(email: user_email)
    if user.present? && user.valid_password?(user_password)
      sign_in(user, store: false)
      user.generate_auth_token!
      user.save
      render json: user, status: :ok, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" },
        status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_auth_token!
    user.save
    head :no_content
  end

  private

  def require_email_and_password
    if user_email.blank? || user_password.blank?
      render json: { errors: "Must provide email and password" }, status: :bad_request
    end
  end

  def user_email
    @user_email ||= params[:session][:email]
  end

  def user_password
    @user_password ||= params[:session][:password]
  end
end
