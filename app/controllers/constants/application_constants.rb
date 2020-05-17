module ApplicationConstants
  PAGINATION_OPTIONS = {
    max_per_page: 30,
    page: 1
  }.freeze

  ORDER_MODIFICATION_ACCESS = ['admin', 'waiter'].freeze

  JWT_TOKEN_EXPIRY_TIME = 24.hours.from_now.freeze

  ERROR_MESSAGES = {
    UPDATE_NOT_ALLOWED: "Update not allowed for %s"
  }.freeze
end.freeze