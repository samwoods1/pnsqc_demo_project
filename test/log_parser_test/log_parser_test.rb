require 'minitest/autorun'
require_relative '../framework/demo_log_parser'

class MyTest < Minitest::Test

  # Simple test to test parsing the log files to determine unique top stacks.
  def test_parse_log
    DemoLogParser.parse('/Users/samwoods/RubymineProjects/pnsqc_demo/test/tests/logs/10_06_2015_09_16_16/', '/tests/')
  end
end
