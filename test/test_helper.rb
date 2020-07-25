ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'json_expressions/minitest'

class ActiveSupport::TestCase
  include ErrorConstants
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  private

    def generate_jwt(user)
      token = JsonWebToken.encode({user_id: user.id, role:user.role})
      Redis.current.set(token, @user.id)
      token
    end

    def error_response(error)
      { errors: [*error] }
    end
end
