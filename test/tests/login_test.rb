require '../framework/demo_logger'
require_relative 'base_test'
require_relative '../utilities/web_request_helpers'

class LoginTest < BaseTest

  # Since these are tests for logging in, there isn't any additional stuff we need to do in setup or teardown methods.

  def test_login_succeeds
    AllPages.login_page.log_in(validate_success: false)
    assert(AllPages.landing_page.page_loaded? true)
  end

  def test_invalid_login_fails
    user = User.new
    user.password = 'incorrect'
    AllPages.login_page.log_in(validate_success: false, user: user,)
  end

  def test_this_one_fails_assertion
    AllPages.login_page.log_in(validate_success: false)
    # This will fail
    refute(AllPages.landing_page.page_loaded?(true), 'Failing assertion on purpose')
  end

  def test_this_test_raises_exception
    AllPages.login_page.log_in()
    raise 'Raising exception on purpose'
  end

  def test_this_test_calls_page_method_that_raises_exception
    AllPages.login_page.log_in
    AllPages.landing_page.raises_exception
  end

  def test_this_does_stuff_then_also_calls_page_method_that_raises_exception
    AllPages.login_page.log_in
    AllPages.landing_page.page_loaded?
    AllPages.landing_page.raises_exception
  end

  def test_this_eventually_raises_exception
    AllPages.login_page.log_in
    AllPages.landing_page.eventually_raises_exception(true)
  end

  def test_this_also_eventually_raises_exception_with_one_missing_frame
    AllPages.login_page.log_in
    AllPages.landing_page.page_loaded?
    AllPages.landing_page.eventually_raises_exception(false)
  end

end
