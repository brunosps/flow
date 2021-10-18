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

    def failure?
      !@is_success
    end

    def success?
      @is_success
    end

    def then(step : Flow::Step.class, params : U) : (Flow::Result) forall U
      return self if self.failure?
      step.call(merge_data(params))
    end

    def then(step : Flow::Step.class) : (Flow::Result) forall U
      return self if self.failure?
      self.then(step, {} of String => String)
    end
  end
end
