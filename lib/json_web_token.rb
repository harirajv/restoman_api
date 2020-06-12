class JsonWebToken
  include ApplicationConstants

  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s.freeze

  def self.encode(payload)
    payload[:iat] = Time.now.to_i
    payload[:exp] = Time.now.to_i + JWT_EXPIRY_TIME.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end
end
