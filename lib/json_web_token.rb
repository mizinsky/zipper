# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload)
    JWT.encode payload.merge(exp: 15.minutes.from_now.to_i), Rails.application.credentials.secret_key_base
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base).first
  end
end
