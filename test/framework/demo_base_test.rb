require 'minitest/autorun'
require_relative 'demo_driver'
require_relative 'demo_log_parser'

# Monkey patch Minitest Test to log assertions and exceptions to our log file.
module Minitest
  class Test
    def capture_exceptions # :nodoc:
      yield
    rescue *PASSTHROUGH_EXCEPTIONS
      raise
    rescue Assertion => e
      DemoLogger.log.error "Assertion failed '#{e.message}'"
      e.backtrace.each { |line| DemoLogger.log.error line }
      self.failures << e
    rescue Exception => e
      DemoLogger.log.error "Unhandled exception occurred '#{e.message}'"
      e.backtrace.each { |line| DemoLogger.log.error line }
      self.failures << UnexpectedError.new(e)
    end
  end
end

# Run before all tests
def before_run
  DemoLogger.log.info("----------------------- Minitest - starting class setup -----------------------")
  Minitest.after_run {
    DemoLogger.log.info("----------------------- Minitest - starting class teardown -----------------------")
    # Log the unique top stack traces.
    DemoLogParser.parse(DemoLogger.log_directory, '/tests/')
  }
end

before_run
# This is primarily for logging and creating, then destroying the selenium driver object.
class DemoBaseTest < Minitest::Test
  # Static, lazy loaded instance of driver
  def self.driver
    @@driver ||= DemoDriver.new.driver
  end

  # Change the log file name to the name of the currently executing test.
  def before_setup
    DemoLogger.set_log_file self.location + '.log'
    DemoLogger.log.info("----------------------- Minitest - starting setup for test '#{self.location}' -----------------------")
  end

  def after_setup
    DemoLogger.log.info("----------------------- Minitest - finished setup for test '#{self.location}' -----------------------")
    DemoLogger.log.info("----------------------- Minitest - starting test '#{self.location}' -----------------------")
  end

  def before_teardown
    DemoLogger.log.info("----------------------- Minitest - finished test '#{self.location}' -----------------------")

    # If the test did not pass, take a screenshot and log that it failed.
    if !self.passed?
      path = File.realpath(DemoLogger.log_directory) + "/#{self.location}.png"
      DemoBaseTest.driver.save_screenshot(path)
      DemoLogger.log.info("----------------------- Minitest - test '#{self.location}' failed! -----------------------\n     -Screenshot at #{path}")
    end

    # Log the location of the log files (so if you're in console it is easy to find)
    DemoLogger.log.info(" Logs available at #{File.realpath(DemoLogger.log_directory)}")
    DemoLogger.log.info("----------------------- Minitest - starting teardown for test '#{self.location}' -----------------------")
  end

  def after_teardown
    DemoLogger.log.info("----------------------- Minitest - finished teardown for test '#{self.location}' -----------------------")
    # Reset the log file back to the default.
    DemoLogger.set_log_file nil

    # Destroy driver after each run so that it can work with remote browsers, and to ensure a clean environment for new tests.
    @@driver.quit
    @@driver = nil
  end

end
