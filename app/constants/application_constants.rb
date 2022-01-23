module ApplicationConstants
  PAGINATION_OPTIONS = {
    max_per_page: 30,
    page: 1
  }.freeze

  JWT_EXPIRY_TIME = 30.minutes.freeze

  RESET_PASSWORD_TOKEN_EXPIRY_TIME = 1.hour.freeze

  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.freeze
end.freeze