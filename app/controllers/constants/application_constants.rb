module ApplicationConstants
  PAGINATION_OPTIONS = {
    max_per_page: 30,
    page: 1
  }.freeze

  JWT_EXPIRY_TIME = 24.hours.freeze

  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.freeze
end.freeze