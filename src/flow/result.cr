module Flow
  class Result(H)
    property is_success : Bool
    property data : H
    property result_type : String

    def initialize(@is_success : Bool, @data : H, @result_type : String)
      @response = Flow::Response.new
    end

    def merge_data(input : Hash)
      params = Flow::Utils::MergeParams.new(self.data.as(Hash)).merge(input)
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

    def on_failure(&block : Flow::Result(H) -> U) : (Flow::Result) forall U
      block.call(self) if self.failure? && !self.returned? && self.result_type != "exception"
      self
    end

    def on_failure(result_type_sym : String, &block : Flow::Result(H) -> U) : (Flow::Result) forall U
      on_failure(&block) if self.result_type == result_type_sym
      self
    end

    def on_failure(result_types : Array(String), &block : Flow::Result(H) -> U) : (Flow::Result) forall U
      on_failure(&block) if result_types.find { |res| res === self.result_type }
      self
    end

    def on_failure(*result_types, &block : Flow::Result(H) -> U) : (Flow::Result) forall U
      on_failure(&block) if result_types.find { |res| res === self.result_type }
      self
    end

    def on_exception(&block : Flow::Result(H) -> U) : (Flow::Result) forall U
      block.call(self) if self.failure? && self.result_type == "exception" && !self.returned?
      self
    end

    def on_success(&block : Flow::Result(H) -> U) : (Flow::Result) forall U
      block.call(self) if self.success? && !self.returned?
      self
    end

    include Flow::Response::Helpers
  end
end
