class ApplicationController < ActionController::API
  attr_reader :current_user

  protected

  def authenticate_user!
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last

    return render_unauthorized unless token

    payload = JwtService.decode(token)
    @current_user = User.find(payload['user_id'])
  rescue JWT::DecodeError, Mongoid::Errors::DocumentNotFound
    render_unauthorized
  end

  def render_unauthorized
    render json: {error: 'Unauthorized' }, status: :unauthorized
  end
end
