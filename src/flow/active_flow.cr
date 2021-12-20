module Flow
  class ActiveFlow
    @@steps = Array(Flow::Step.class).new

    def self.step(klass : Flow::Step.class)
      enqueue klass
    end

    def self.enqueue(step : Flow::Step.class)
      @@steps << step
    end

    def self.call(input : Lucky::Params)
      call(input.to_h)
    end

    def self.call(input : Hash)
      new.call(input)
    end

    def call(input : Hash)
      result = Flow::Result(typeof(input)).new(true, input, "ok")

      @@steps.each do |step|
        result = step.call(result)
        return result if result.failure?
      end

      result
    end
  end
end
