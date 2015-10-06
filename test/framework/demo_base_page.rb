require 'selenium-webdriver'
require_relative '../framework/demo_element'
require_relative '../framework/demo_logger'
require_relative '../framework/demo_selenium_event_listener'

# All page classes should inherit from this.
class DemoBasePage

  # @url should optionally be set in child classes.  It is only necessary if you want to navigate directly to the page.
  @url
  # An array of elements that must be displayed in order to determine that the correct page is loaded.
  # Should be set in the child page constructor.
  @page_load_indicator
  # Should be set in a project specific base page class and contain any logic for different test environments.
  @base_url

  def initialize()
    # The default timeout can be overridden for specific pages.  Set @page_timeout in child page class.
    @page_timeout = DemoElementWait.default_page_load_timeout
  end

  # visits the page
  def visit
    DemoBaseTest.driver.get(@base_url + @url)
    self.page_loaded?
  end

  # Ensures the initial page load is completed, (if your site uses jquery) then checks to see if the specified
  # element or elements exist and throws an exception by default, or returns a true/false value if desired.
  def page_loaded?(throw_on_fail = true)
    # If a single element is specified instead of an array, convert it to an array of elements
    if @page_load_indicator != nil && @page_load_indicator != []
      if @page_load_indicator.class.ancestors.include?(DemoElement)
        @page_load_indicator = [@page_load_indicator]
      end
    end

    # Wait up to the page's timeout value for the page and all indicators to be displayed.
    wait = Selenium::WebDriver::Wait.new({ :timeout => @page_timeout })
    result = wait.until {
      DemoElementWait.wait_for_page_loaded(@page_timeout)
      @page_load_indicator.each do |indicator|
        return false if !indicator.displayed?
      end
      return true
    }

    # Throw an exception by default
    if throw_on_fail && !result
      raise "The page '#{self.class.name}' is not displayed"
    end

    #return true/false if success, or throw_on_fail is false.
    result
  end
end

