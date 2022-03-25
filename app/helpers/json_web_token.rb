class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s.freeze

  def self.encode(payload)
    payload[:iat] = Time.now.to_i
    payload[:exp] = Time.now.to_i + ApplicationConstants::JWT_EXPIRY_TIME.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(decoded)
  end

  def self.generate_token(user)
    token = JsonWebToken.encode({
      account_id: user.account_id,
      user_id: user.id,
      role: user.role
    })
    Redis.current.set(token, user.account_id)
    Redis.current.expire(token, ApplicationConstants::JWT_EXPIRY_TIME)
    token
  end
end
