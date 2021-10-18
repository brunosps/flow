module Flow
  class FailureException < Exception
    getter :failure_type
    getter :data

    def initialize(@failure_type : String, @message : String, @data : JSON::Any)
    end
  end
end
