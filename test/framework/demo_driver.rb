class DemoDriver
  attr_reader :driver

  def initialize
    client         = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = 60 # default seconds to wait for page to load
    @driver = Selenium::WebDriver.for(:chrome, :http_client => client, :listener => DemoSeleniumEventListener.new)
  end

end
