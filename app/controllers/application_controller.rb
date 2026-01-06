class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password])
  end

  def authenticate_user!(opts = {})
    token = request.headers['Authorization']&.split(' ')&.last
    Rails.logger.info "JWT Token received: #{token&.slice(0, 20)}..."
    Rails.logger.info "JWT Secret configured: #{Devise.jwt.secret.present?}"

    super
  rescue => e
    Rails.logger.error "JWT Auth failed: #{e.class} - #{e.message}"
    render json: { error: 'Unauthorized', details: e.message }, status: :unauthorized
  end
end
