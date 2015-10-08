require 'minitest/autorun'
require_relative '../framework/demo_log_parser'

class MyTest < Minitest::Test

  # Simple test to test parsing the log files to determine unique top stacks.
  def test_parse_log
    DemoLogParser.parse('/Users/samwoods/puppet_repos/pnsqc_demo_project/test/tests/logs/10_07_2015_20_09_16/', '/tests/')
  end
end
