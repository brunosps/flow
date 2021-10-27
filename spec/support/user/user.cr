require "uuid"

class User
  property id : UUID
  property name : String
  property email : String

  def initialize(@name, @email)
    @id = UUID.random
  end
end
