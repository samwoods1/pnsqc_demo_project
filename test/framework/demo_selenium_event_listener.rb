require 'selenium-webdriver'
require_relative 'demo_logger'

# Add logging at Selenium events
class DemoSeleniumEventListener < Selenium::WebDriver::Support::AbstractEventListener
  def after_navigate_to(url, driver)
    DemoLogger.log.info("Selenium - Navigated to #{url}")
  end

  def before_find(by, what, driver)
    DemoLogger.log.info("Selenium - Finding element by #{by}, locator: #{what}")
  end

  def before_click(element, driver)
    # Creating a human readable representation of the element based on it's HTML, since we don't have the 'by' available here.
    element_identifier = "'"
    element_identifier += " Tag: #{element.tag_name},"
    element_identifier += " ID: #{element.attribute('id')}," unless element.attribute('id') == ''
    element_identifier += " Class: #{element.attribute('class')}," unless element.attribute('class') == ''
    element_identifier += " Text: #{element.text}," unless (element.text == '')
    element_identifier = element_identifier.gsub(/\*\,/, "'")

    DemoLogger.log.info("Selenium - Clicking on #{element_identifier}")
    # Used to check to see if we transition to a new page
    @pre_click_url = driver.current_url
    @pre_click_title = driver.title
  end

  def after_click(element, driver)
    # If we transitioned to a new page after the click, log it.
    DemoLogger.log.info("Selenium - Navigated to new URL: #{driver.current_url}") unless @pre_click_url == driver.current_url
    DemoLogger.log.info("Selenium - Page title changed to: #{driver.title}") unless @pre_click_url = driver.title
  end

end
