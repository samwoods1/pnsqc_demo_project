class Helpers
  # Will return a random string.
  # @param [Int] len The number of chars the generated string should contain.
  # @return [String] An alphanumeric string.
  def self.rand_alphanumeric(len = 8)
    chars = 'ACDEFGHJKLMNPQRTWXYZ0234679' # exclude ambiguous chars, like ('8' and 'B') or ('1' and 'L')
    alphanumeric = ''
    len.times { alphanumeric << chars[rand(chars.size)] }
    alphanumeric
  end

  #Any date within 100 years
  def self.date_rand from = Time.now - (60*60*24*365*50), to = Time.now
    Time.at(from + rand * (to.to_f - from.to_f)).strftime( "%m/%d/%Y" )
  end

end
