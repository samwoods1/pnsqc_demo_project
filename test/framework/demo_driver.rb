class DemoDriver
  attr_reader :driver

  #TODO: Include logic to use different browsers/capabilities either via command line arguments, config file or environment variables
  def initialize
    # Create an instance of the selenium driver.
    client         = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 60 # default seconds to wait for responses from web requests to the application server
    @driver = Selenium::WebDriver.for(:chrome, :http_client => client, :listener => DemoSeleniumEventListener.new)
  end

end
