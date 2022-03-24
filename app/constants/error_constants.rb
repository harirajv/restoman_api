module ErrorConstants
  ERROR_MESSAGES = {
    invalid_params: "Invalid parameters %s",
    invalid_user_email: "User with email: %s doesn't exist",
    invalid_password: "Password is invalid",
    logged_out: 'You are logged out. Please login again.',
    missing_params: 'Parameters missing',
    nil_token: "Nil JSON web token",
    not_privileged: "Insufficient privileges",
    record_not_found: "Couldn't find %s with '%s'=%s",
    token_expired: 'Token expired',
    update_not_allowed: "Update not allowed for %s"
  }.freeze
end.freeze
