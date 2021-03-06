require_relative '../framework/demo_base_test'
require_relative '../pages/all_pages'
require_relative '../utilities/web_request_helpers'

class BaseTest < DemoBaseTest
  #include AllPages
  def setup
    # Create an instance of WebRequestHelpers so we can do some actions using the web service directly.
    @web_request_helper = WebRequestHelpers.new
    # Resets all of the pages (and elements) after each test (avoids stale elements)
    AllPages.new
    # Navigates to the login page
    AllPages.login_page.visit
  end

  def teardown
  end

end
