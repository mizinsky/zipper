# frozen_string_literal: true

module Api
  class LoginController < ApiController
    skip_before_action :authenticate_token!

    def create
      user = authenticate_user

      if user
        render json: { token: JsonWebToken.encode(user_id: user.id) }
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end

    private

    def authenticate_user
      user = User.find_by(email: params[:user][:email])
      user if user&.valid_password?(params[:user][:password])
    end
  end
end
