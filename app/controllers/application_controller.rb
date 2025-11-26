class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    if token.nil?
      render json: { error: 'Missing token' }, status: :unauthorized
      return
    end

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')[0]
      @current_user = User.find(decoded["user_id"])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "User not found" }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end
end
