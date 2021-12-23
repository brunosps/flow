module Flow
  module Failure
    def failure(failure_type : String, message : String, data : Hash)
      new_data = {"errors" => {
        "type"    => failure_type,
        "message" => message,
      }.merge(data)}
      Flow::Result(typeof(new_data)).new(false,
        new_data,
        failure_type)
    end

    def failure(failure_type : String, message : String)
      data = {} of String => Hash(String, String)
      failure(failure_type, message, data)
    end

    def failure(failure_type : String, data : Hash)
      message = failure_type
      failure(failure_type, message, data)
    end

    def failure(message : String)
      failure_type = "error"
      data = {} of String => Hash(String, String)
      failure(failure_type, message, data)
    end
  end
end
