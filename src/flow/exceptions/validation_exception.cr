module Flow
  class ValidationException < Exception
    def initialize(@message : String, @data : Hash(String, Array(String)))
    end

    def data
      @data
    end
  end
end
