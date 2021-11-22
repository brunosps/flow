module Flow
  class ValidationException(U) < Exception
    property data : U

    def initialize(@message : String, @data : U)
    end
  end
end
