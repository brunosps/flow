module Flow
  class Result(H)
    getter is_success : Bool
    getter data : H
    getter result_type : String

    def initialize(@is_success : Bool, @data : H, @result_type : String)
    end

    def merge_data(input : Hash)
      params = input.merge(self.data)
      Flow::Result(typeof(params)).new(self.is_success, params, self.result_type)
    end
  end
end
