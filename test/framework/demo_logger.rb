require 'logger'

class DemoLogger
  @@default_log_file = 'demo_automation_log'

  @@log
  @@log_directory
  @@log_file ||= @@default_log_file

  def self.log
    @@log ||= get_loggers
  end

  def self.log_directory
    @@log_directory ||= "logs/#{DateTime.now.strftime '%m_%d_%Y_%H_%M_%S'}/"
  end

  def self.set_log_file(log_file)
    @@log_file = log_file
    @@log = DemoLogger.get_loggers
  end

  def self.default_log_file
    @@default_log_file
  end

  def self.get_loggers
    FileUtils::makedirs "#{DemoLogger.log_directory}"
    file_logger = Logger.new("#{DemoLogger.log_directory}#{@@log_file}")
    file_logger.level = 1 # info
    console_logger = Logger.new(STDOUT)
    console_logger.level = 1 # info

    DemoMultiLogger.new([file_logger, console_logger])
  end

  class DemoMultiLogger < Logger
    @@loggers = []

    def initialize(loggers)
      @@loggers = loggers
    end

    def add(severity, message = nil, progname = nil, &block)
      @@loggers.each do |logger|
        logger.add(severity, message, progname, &block)
      end
    end
    alias log add
  end
end
