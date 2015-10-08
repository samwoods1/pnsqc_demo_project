require_relative '../utilities/helpers'

# User class, representing a user for the Insurance Company web site.
class User
  # Constructor using default values if none are provided, or using randomize = true to generate random values.
  attr_accessor :email, :password, :first_name, :last_name, :birthday, :address, :city, :state, :postal_code

  def initialize(email = nil, password = nil, first_name = nil, last_name = nil,
                 birthday = nil, address = nil, city = nil, state = nil,
                 postal_code = nil, randomize: false)

    # Set all of the values to what was passed in the constructor
    @email       = email
    @password    = password
    @first_name  = first_name
    @last_name   = last_name
    @birthday    = birthday
    @address     = address
    @city        = city
    @state       = state
    @postal_code = postal_code

    # Set anything that is nil to a random value if it is specified.
    if randomize
      @email       ||= "#{Helpers.rand_alphanumeric(15)}@foo_bar.com"
      @password    ||= Helpers.rand_alphanumeric(8) + '1!' # Make sure there is at least one number and a special character
      @first_name  ||= Helpers.rand_alphanumeric(5)
      @last_name   ||= Helpers.rand_alphanumeric(5)
      @birthday    ||= Helpers.date_rand
      @address     ||= "#{rand(1...3000)} #{Helpers.rand_alphanumeric(5)} st"
      @city        ||= Helpers.rand_alphanumeric(5)
      @state       ||= 'Nevada'
      @postal_code ||= rand(10000...99999)
    end

    # Set anything that is still nil to defaults
    @email       ||= 'the_donald@foo_bar.com'
    @password    ||= 'password'
    @first_name  ||= 'Donald'
    @last_name   ||= 'Trump'
    @birthday    ||= '01/07/1970'
    @address     ||= '1 Trump Tower'
    @city        ||= 'Las Vegas'
    @state       ||= 'Nevada'
    @postal_code ||= '95555'

  end

end
