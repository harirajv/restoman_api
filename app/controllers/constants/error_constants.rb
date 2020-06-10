module ErrorConstants
  ERROR_MESSAGES = {
    cant_be_blank: "can't be blank",
    greater_than_equal: "must be greater than or equal to %0.2f",
    greater_than_equal_integer: "must be greater than or equal to %d",
    is_invalid: "is invalid",
    too_short_min_is: "is too short (minimum is %d characters)",
    invalid_user_email: "User with email: %s doesn't exist",
    UPDATE_NOT_ALLOWED: "Update not allowed for %s"
  }.freeze
end.freeze
