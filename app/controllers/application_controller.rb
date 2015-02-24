require "application_responder"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  self.responder = ApplicationResponder
  respond_to :html
  include Authenticable

  protected

  def authorize!
    friendly_id = params[:id] || params[:user_id]
    if User.friendly.find(friendly_id) != current_user
      render json: { errors: "Not authorized" }, status: :unauthorized
    end
  end
end
