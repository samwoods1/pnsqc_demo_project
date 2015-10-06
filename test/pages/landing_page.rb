require_relative 'base_page'

class LandingPage < BasePage
  def initialize
    @logout_form = DemoElement.new '#logout-form'
    @logout_button = DemoElement.new "input[alt='logout']", @logout_form
    @page_load_indicator = @logout_button
    super
  end
end
