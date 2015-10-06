require_relative '../framework/demo_base_test'
require_relative '../pages/all_pages'

class BaseTest < DemoBaseTest
  #include AllPages
  def setup
    # Resets all of the pages (and elements) after each test (avoids stale elements)
    AllPages.new
    # Navigates to the login page
    AllPages.login_page.visit
  end

  def teardown
  end

end
