require_relative 'base_test'

class MyTest < BaseTest

  _known_issue 'PUP-5346'
  def test_known_issue_not_fixed
    return true
  end

  _known_issue 'PUP-5243'
  def test_known_issue_fixed
    return true
  end

  # TODO: implement this
  # _known_issue ''
  # def test_known_issue_closed_not_fixed
  #   return true
  # end

  _known_issue 'TEST-12345'
  def test_known_issue_not_exists
    return true
  end

end
