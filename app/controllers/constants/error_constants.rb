module ErrorConstants
  ERROR_MESSAGES = {
    already_taken: "has already been taken",
    cant_be_blank: "can't be blank",
    greater_than_equal: "must be greater than or equal to %0.2f",
    greater_than_equal_integer: "must be greater than or equal to %d",
    invalid_user_email: "User with email: %s doesn't exist",
    invalid_password: "Password is invalid",
    is_invalid: "is invalid",
    nil_token: "Nil JSON web token",
    too_short_min_is: "is too short (minimum is %d characters)",
    not_privileged: "Insufficient privileges",
    record_not_found: "Couldn't find %s with '%s'=%s",
    update_not_allowed: "Update not allowed for %s"
  }.freeze
end.freeze
