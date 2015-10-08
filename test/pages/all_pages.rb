require_relative 'login_page'
require_relative 'landing_page'
require_relative 'registration_page'

# Class with static instances of all pages
class AllPages
  attr_reader :login_page, :landing_page

  # Used to reset pages between tests.
  def initialize
    @@login_page = LoginPage.new
    @@landing_page = LandingPage.new
    @@registration_page = RegistrationPage.new
  end

  def self.login_page
    @@login_page
  end

  def self.landing_page
    @@landing_page
  end

  def self.registration_page
    @@registration_page
  end
end
