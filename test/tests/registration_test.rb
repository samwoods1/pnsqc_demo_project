require '../framework/demo_logger'
require_relative 'base_test'
require_relative '../utilities/web_request_helpers'

class RegistrationTest < BaseTest

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @web_request_helper = WebRequestHelpers.new
    AllPages.new
    AllPages.registration_page.visit
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    super
  end

  # This test uses a randomly generated user with all random string values
  def test_registration_succeeds
    user = User.new randomize: true
    # Submit, but don't validate success, so we can assert below
    AllPages.registration_page.register(submit: true, validate_success: false, user: user)

    assert(AllPages.registration_page.validate_registration_success, 'The success page was not displayed after registration')
  end

  def test_service_registration_succeeds
    user = User.new randomize: true
    # Submit, but don't validate success, so we can assert below
    @web_request_helper.service_register_user user

    AllPages.login_page.visit(false)

    assert(AllPages.landing_page.page_loaded?(false), 'The user was not successfully registered or could not log in.')
  end

end
