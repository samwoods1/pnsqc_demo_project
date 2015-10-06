require 'selenium-webdriver'
require_relative 'demo_logger'

class DemoElementWait

  @@default_page_load_timeout
  @@default_element_timeout

  def self.default_page_load_timeout
    @@default_page_load_timeout ||= 30
  end

  def self.default_element_timeout
    @@default_element_timeout ||= 30
  end

  def self.wait_for(secs = DemoElementWait.default_page_load_timeout)
    Selenium::WebDriver::Wait.new(:timeout => secs).until do
      yield
    end
  end

  # Yields whether the WebDriver::Wait has been successful or not after waiting the specified number of seconds
  # for the condition to be met.
  # @param [Integer] secs optional otherwise will use the default set in DefaultConstants
  #   or what has been set in Beaker options hash.
  # @yield [Boolean]
  def self.wait_for?(secs = DemoElementWait.default_element_timeout)
    begin
      Selenium::WebDriver::Wait.new(:timeout => secs).until do
        yield
      end
    rescue Selenium::WebDriver::Error::TimeOutError
      false
    end
  end

  # Only works for pages using jQuery.  Additional implementation necessary if not using jQuery
  # Waits up to 10 seconds for the page to be loaded. Should be called anytime we create a WebElement object.
  def self.wait_for_page_loaded(secs = DemoElementWait.default_page_load_timeout)
    DemoLogger.log.info('wait for page to be loaded')
    wait = Selenium::WebDriver::Wait.new({ :timeout => secs })
    begin
      wait.until { BaseTest.driver.execute_script ('return jQuery.active == 0') }
    rescue
      Selenium::WebDriver::Error::JavascriptError
    end
  end
end
