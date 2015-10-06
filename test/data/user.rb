# User class, representing a user for the Insurance Company web site.
class User
  # Constructor using default values if none are provided
  attr_accessor :email, :password, :first_name, :last_name, :birthday, :mailing_address, :city, :state, :postal_code

  def initialize(email = 'the_donald@foo_bar.com', password = 'password', first_name = 'Donald', last_name = 'Trump',
                 birthday = '01/07/1970', mailing_address = '1 Trump Tower', city = 'Las Vegas', state = 'Nevada',
                 postal_code = '95555')
    @email           = email
    @password        = password
    @first_name      = first_name
    @last_name       = last_name
    @birthday        = birthday
    @mailing_address = mailing_address
    @city            = city
    @state           = state
    @postal_code     = postal_code
  end

end
