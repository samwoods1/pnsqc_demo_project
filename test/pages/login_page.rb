require_relative 'base_page'
require_relative '../data/user'
require_relative 'all_pages'

class LoginPage < BasePage


  def initialize
    @login_form = DemoElement.new('#login-form')
    @login_email = DemoElement.new("input[type='text']", @login_form)
    @login_password = DemoElement.new("input[type='password']", @login_form)
    @login_button = DemoElement.new("input[alt='Login']", @login_form)
    @signup_button = DemoElement.new("input[alt='Signup']", @login_form)

    @url = 'index.jsf'
    @page_load_indicator = @login_button
    super
  end

  # Logs in, optionally submits, and optionally validates success.
  def log_in(submit: true, validate_success: true, user: User.new)
    # Logging at the page level
    DemoLogger.log.info("Logging in with user '#{user.email}'")
    @login_email.send_keys(user.email)
    @login_password.send_keys(user.password)
    @login_button.click if submit
    if !submit
      DemoLogger.log.info('Entered user credentials into login form, not submitting')
      return true
    end

    # If you want to assert on this in your test, or if you expect a failure, set validate_success to false.
    AllPages.landing_page.page_loaded? if validate_success
    DemoLogger.log.info("Successfully loged in with user '#{user.email}'")
  end

  # Helper to sign up for a new user
  # spans multiple pages
  def sign_up(user)
    DemoLogger.log.info("Signing up with new user")
    @signup_button.click
    AllPages.registration_page.register(user)
  end
end
