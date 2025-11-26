class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]

  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user_response(user), token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user_response(user), token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def show
    render json: { user: @current_user }, status: :ok
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def user_response(user)
    { id: user.id, email: user.email }
  end
end
