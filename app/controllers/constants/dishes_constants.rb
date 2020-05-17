module DishesConstants
  RESTRICTED_ACTIONS = HashWithIndifferentAccess.new({
    admin: %w(),
    waiter: %w(create update destroy),
    chef: %w(create destroy)
  }).freeze

  UPDATE_ALLOWED_FIELDS = HashWithIndifferentAccess.new({
    admin: %w(name description cost image is_active),
    waiter: %w(),
    chef: %w(is_active)
  }).freeze
end.freeze
