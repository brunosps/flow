module Flow
  module Callback(R)
    def on_success(&block : Flow::Result(R) -> U) : (Flow::Result(R) | U) forall R, U
      block.call(self) if self.success? && !self.returned?
      self
    end

    def on_failure(&block : Flow::Result(R) -> U) : (Flow::Result(R) | U) forall R, U
      block.call(self) if self.failure? && !self.returned?
      self
    end

    def on_failure(result_type_sym : String, &block : Flow::Result(R) -> U) : (Flow::Result(R) | U) forall R, U
      on_failure(&block) if self.result_type == result_type_sym
      self
    end

    def on_failure(result_types : Array(String), &block : Flow::Result(R) -> U) : (Flow::Result(R) | U) forall R, U
      on_failure(&block) if result_types.find { |res| res === self.result_type }
      self
    end

    def on_failure(*result_types, &block : Flow::Result(R) -> U) : (Flow::Result(R) | U) forall R, U
      on_failure(&block) if result_types.find { |res| res === self.result_type }
      self
    end

    def on_exception(&block : Flow::Result(R) -> U) : (Flow::Result(R) | U) forall R, U
      on_failure(&block) if self.result_type == "exception"
      self
    end
  end
end
