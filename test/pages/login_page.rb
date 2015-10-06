require_relative 'base_page'
require_relative '../data/user'
require_relative 'all_pages'

class LoginPage < BasePage

  def initialize
    super
    @url = 'index.jsf'
    @login_form = DemoElement.new('#login-form')
    @login_email = DemoElement.new("input[type='text']", @login_form)
    @login_password = DemoElement.new("input[type='password']", @login_form)
    @login_button = DemoElement.new("input[alt='Login']", @login_form)

    @page_load_indicator = @login_button
  end

  def log_in(submit = true, expect_success = true, user: User.new)

    DemoLogger.log.info("Logging in with user '#{user.email}'")
    @login_email.send_keys(user.email)
    @login_password.send_keys(user.password)
    @login_button.click if submit
    AllPages.landing_page.page_loaded? if expect_success
  end
end
