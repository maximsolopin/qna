require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:display_name, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:display_name, :email, :password) }
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.js { render nothing: true, error: exception.message }
      format.json { render nothing: true, error: exception.message }
    end
  end

  check_authorization unless: :devise_controller?
end
