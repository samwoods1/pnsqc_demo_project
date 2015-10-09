require 'minitest/autorun'
require_relative 'demo_driver'
require_relative 'demo_logger'
require_relative 'demo_log_parser'
require_relative 'demo_known_issue'
require_relative 'annotations'

# Monkey patch Minitest Test to log assertions and exceptions to our log file.
module Minitest
  class Test

    # Extend Minitest Test to use Annotations
    extend Annotations

    def capture_exceptions # :nodoc:
      yield
    rescue *PASSTHROUGH_EXCEPTIONS
      raise
    rescue Assertion => e
      # Don't need to log the whole stack trace if we're just skipping a test
      if !e.message.include? "SKIPPING TEST - "
        DemoLogger.log.error "Assertion failed '#{e.message}'"
        e.backtrace.each { |line| DemoLogger.log.error line }
        self.failures << e
      else
        # Still want to log the message so we know the test was skipped.
        DemoLogger.log.error e.message
      end
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
  include KnownIssue

  # Static, lazy loaded instance of driver
  def self.driver
    @@driver ||= DemoDriver.new.driver
  end

  # Override the run function to check for any known_issue annotations, so we can skip not only the test,
  # but all setup and teardown methods as well.
  # If there are no known_issue annotations for the method, call the super version.
  def run
    skip_message = nil
    DemoLogger.set_log_file self.location + '.log'
    DemoLogger.log.info("----------------------- Minitest - starting setup for test '#{self.location}' -----------------------")
    if self.class.annotations && self.class.annotations[self.location[self.location.index('#') + 1, self.location.length].to_sym]
      known = self.class.annotations[self.location[self.location.index('#') + 1, self.location.length].to_sym][:known_issue]
      if known != nil && known != ''
        skip_message = known_issue known
      end
      if skip_message
        with_info_handler do
          time_it do
            capture_exceptions do
              skip(skip_message)
            end
          end
        end
      end
    end
    super if skip_message.nil?
    self
  end

  # Change the log file name to the name of the currently executing test.
  def before_setup

  end

  def after_setup
    DemoLogger.log.info("----------------------- Minitest - finished setup for test '#{self.location}' -----------------------")
    DemoLogger.log.info("----------------------- Minitest - starting test '#{self.location}' -----------------------")
  end

  def before_teardown
    DemoLogger.log.info("----------------------- Minitest - finished test '#{self.location}' -----------------------")

    # If the test did not pass, take a screenshot and log that it failed.
    if !self.passed? && !self.skipped?
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
