require '../framework/demo_logger'
require_relative 'base_test'

class LoginTest < BaseTest

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    super

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
    AllPages.landing_page.eventually_raises_exception
  end

  def test_this_also_eventually_raises_exception
    AllPages.login_page.log_in
    AllPages.landing_page.page_loaded?
    AllPages.landing_page.eventually_raises_exception
  end
end
