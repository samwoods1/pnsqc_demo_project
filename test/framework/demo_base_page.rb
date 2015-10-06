require 'selenium-webdriver'
require_relative '../framework/demo_element'
require_relative '../framework/demo_logger'
require_relative '../framework/demo_selenium_event_listener'

class DemoBasePage

  @url
  @page_load_indicator

  def initialize
    @page_timeout = DemoElementWait.default_page_load_timeout
    @base_url = ''
  end

  # visits the page
  def visit
    DemoBaseTest.driver.get(@base_url + @url)
    self.page_loaded?
  end

  # Ensures the initial page load is completed, (if your site uses jquery) then checks to see if the specified
  # element or elements exist and throws an exception by default, or returns a true/false value if desired.
  def page_loaded?(return_boolean = false)
    DemoElementWait.wait_for_page_loaded(@page_timeout)
    if @page_load_indicator != nil && @page_load_indicator != []
      if @page_load_indicator.class.ancestors.include?(DemoElement)
        @page_load_indicator = [@page_load_indicator]
      end
      if return_boolean
        @page_load_indicator.each do |indicator|
          return false if !indicator.displayed?
        end
        return true
      else
        @page_load_indicator.each do |indicator|
          raise "The page '#{self.class.name}' is not displayed" if !indicator.displayed?
        end
      end
    end
  end
end

