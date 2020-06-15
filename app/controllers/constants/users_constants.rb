module UsersConstants
  RESTRICTED_ACTIONS = HashWithIndifferentAccess.new({
    admin: %w(),
    waiter: %w(create destroy),
    chef: %w(create destroy)
  }).freeze

  UPDATE_ALLOWED_FIELDS = HashWithIndifferentAccess.new({
    admin: %w(name role email),
    waiter: %w(name email),
    chef: %w(name email)
  }).freeze
end.freeze
  