require_relative 'base_page'
require_relative '../data/user'
require_relative 'all_pages'

class RegistrationPage < BasePage


  def initialize
    @signup_form = DemoElement.new '#signup'
    @first_name_text = DemoElement.new "input[name='signup:fname']"
    @last_name_text = DemoElement.new "input[name='signup:lname']"
    @birth_date_text = DemoElement.new "#BirthDate"
    @email_text = DemoElement.new "input[name='signup:email']"
    @address_text = DemoElement.new "input[name='signup:street']"
    @city_text = DemoElement.new "input[name='signup:city']"
    @state_drop_down = DemoElement.new "select[name='signup:state']"
    @postal_code_text = DemoElement.new "input[name='signup:zip']"
    @password_text = DemoElement.new "input[name='signup:password']"
    @signup_button = DemoElement.new "input[name='signup:signup']"
    @signup_continue_button = DemoElement.new "input[name='signup:continue']"

    @url = 'signup.jsf'
    @page_load_indicator = @signup_form
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
    DemoLogger.log.info("Successfully logged in with user '#{user.email}'")
  end

  # Helper to sign up for a new user
  # spans multiple pages
  def register(user: User.new, submit:true, validate_success: true)
    DemoLogger.log.info("Signing up for a new user '#{user.email}'")
    @first_name_text.send_keys user.first_name
    @last_name_text.send_keys user.last_name
    @birth_date_text.send_keys user.birthday
    @email_text.send_keys user.email
    @address_text.send_keys user.address
    @city_text.send_keys user.first_name
    # Using custom select_option method to simplify working with dropdowns.
    @state_drop_down.select_option(user.state)
    @postal_code_text.send_keys user.postal_code
    @password_text.send_keys(user.password)
    if submit
      @signup_button.click if submit
      return
    end
  end

  # Was registration successful?
  def validate_registration_success
    @signup_continue_button.displayed?
  end
end
