module ApplicationConstants
  PAGINATION_OPTIONS = {
    max_per_page: 30,
    page: 1
  }.freeze

  ORDER_MODIFICATION_ACCESS = ['admin', 'waiter'].freeze

  JWT_TOKEN_EXPIRY_TIME = 24.hours.from_now.freeze

  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.freeze
end.freeze