require_relative '../framework/demo_base_test'
require_relative '../pages/all_pages'

class BaseTest < DemoBaseTest
  #include AllPages
  def setup
    AllPages.new
    AllPages.login_page.visit
  end

  def teardown
  end

end
