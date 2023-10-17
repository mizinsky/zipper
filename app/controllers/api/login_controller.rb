# frozen_string_literal: true

module Api
  class LoginController < ApiController
    skip_before_action :authenticate_token!

    def create
      user = User.find_by(email: params[:user][:email])

      if user&.valid_password? params[:user][:password]
        render json: { token: JsonWebToken.encode(user_id: user.id) }
      else
        render json: { errors: ['Invalid credentials'] }, status: :unauthorized
      end
    end
  end
end
