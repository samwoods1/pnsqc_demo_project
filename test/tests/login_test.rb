require '../framework/demo_logger'
require_relative 'base_test'

class LoginTest < BaseTest

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    super
    # Do nothing
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.
  def teardown
    super
  end

  def test_login_succeeds
    AllPages.login_page.log_in(true, false)
    assert(AllPages.landing_page.page_loaded? true)
  end

  def test_invalid_login_fails
    user = User.new
    user.password = 'incorrect'
    AllPages.login_page.log_in(true, false, user: user,)
  end

  def test_this_one_fails_assertion
    AllPages.login_page.log_in(true, false)
    # This will fail
    refute(AllPages.landing_page.page_loaded?(true), 'Failing assertion on purpose')
  end

  def test_this_one_raises_exception
    AllPages.login_page.log_in()
    raise 'Raising exception on purpose'
  end
end
