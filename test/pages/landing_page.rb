require_relative 'base_page'

class LandingPage < BasePage
  def initialize
    @logout_form = DemoElement.new '#logout-form'
    @logout_button = DemoElement.new "input[alt='logout']", @logout_form
    @raise_exception_element = DemoElement.new('#i-dont-exist', )
    # Don't want to have to wait 30 seconds when I know it will purposely timeout.
    @raise_exception_element.element_timeout = 3
    @page_load_indicator = @logout_button
    super
  end

  def raises_exception
    raise "I'm just doing what I'm told and raising an exception."
  end

  def eventually_raises_exception
    do_something
  end

  def do_something
    do_something_else
  end

  def do_something_else
    #make a selenium call that will throw an exception
    @raise_exception_element.click
  end

end
