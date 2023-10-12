# frozen_string_literal: true

class ApiController < ApplicationController
  attr_reader :current_user

  skip_before_action :verify_authenticity_token
  before_action :set_format
  before_action :authenticate_token!

  private

  def set_format
    request.format = :json
  end

  def authenticate_token!
    payload = JsonWebToken.decode(auth_token)
    if payload.present?
      @current_user = User.find(payload['user_id'])
    else
      render json: { errors: ['Invalid auth token'] }, status: :unauthorized
    end
  rescue JWT::ExpiredSignature
    render json: { errors: ['Token has expired'] }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { errors: ['Invalid auth token'] }, status: :unauthorized
  end

  def auth_token
    @auth_token ||= request.headers.fetch('Authorization', '').split(' ').last
  end
end
