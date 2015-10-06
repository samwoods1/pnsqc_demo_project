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
class DemoBaseTest < Minitest::Test

  # # TODO: Include logic to use desired capabilities for different browsers here
  # # Static, lazy loaded instance of driver
  def self.driver
    @@driver ||= DemoDriver.new.driver
  end

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
    if !self.passed?
      path = File.realpath(DemoLogger.log_directory) + "/#{self.location}.png"
      DemoBaseTest.driver.save_screenshot(path)
      DemoLogger.log.info("----------------------- Minitest - test '#{self.location}' failed! -----------------------\n     -Screenshot at #{path}")
    end
    DemoLogger.log.info(" Logs available at #{File.realpath(DemoLogger.log_directory)}")
    DemoLogger.log.info("----------------------- Minitest - starting teardown for test '#{self.location}' -----------------------")
  end

  def after_teardown
    DemoLogger.log.info("----------------------- Minitest - finished teardown for test '#{self.location}' -----------------------")
    DemoLogger.set_log_file DemoLogger.default_log_file
    @@driver.quit
    @@driver = nil
  end

end
