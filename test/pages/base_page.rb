require_relative '../framework/demo_base_page'

class BasePage < DemoBasePage
  # TODO: Include logic in this constructor to use different browsers depending on a config file, or passed as command line parameters
  def initialize
    # TODO: Include logic to use a different base URL depending on the environment
    @base_url = 'http://demo.borland.com/InsuranceWebExtJS/'
    super
  end

end
