class Email
  def initialize(@value : String)
    @rx_domain_part = /(?<name>[a-z0-9]{1}[a-z0-9\.\-]*){1,63}\.(?<ext>[a-z]+)/
    @rx_domain = /^#{@rx_domain_part}$/
    @rx_email = /^[a-zA-Z0-9]+[a-zA-Z0-9_\.\-]*@#{@rx_domain_part}$/
  end

  def ==(other : Email)
    self.==(other.value)
  end

  def ==(other : String)
    self.value == other
  end

  def valid?
    email?(value)
  end

  def value
    @value
  end

  private def email?(value : String) : Bool
    size = value.size

    return false if size > 60 || size < 7
    return false if value.includes?("..")
    return false if value.includes?("--")
    return false if value.includes?("___")
    return false unless m = value.match(@rx_email)

    self.domain? "#{m["name"]}.#{m["ext"]}"
  end

  private def domain?(value : String) : Bool
    size = value.size
    return false if size > 75 || size < 4
    return false if value.includes?("..")
    return false unless m = value.match(@rx_domain)

    # domain extension
    ext_size = m["ext"].size
    return false if ext_size < 2 || ext_size > 12

    true
  end
end
