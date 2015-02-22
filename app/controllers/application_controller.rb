require "application_responder"

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  self.responder = ApplicationResponder
  respond_to :html
  include Authenticable
end
