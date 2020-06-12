ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  include ErrorConstants
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  private

    def generate_jwt(user)
      JsonWebToken.encode({user_id: user.id, role:user.role})
    end

    def parsed_response
      HashWithIndifferentAccess.new(JSON.parse(response.body))
    end
end
