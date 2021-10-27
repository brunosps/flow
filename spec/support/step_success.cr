class StepSuccess < Flow::Step
  @[Flow::Property(required: true)]
  property one : Int32?

  @[Flow::Property]
  property two : Int32 = 0

  def call : Flow::Result
    Flow::Result.new(true, {"one" => one, "two" => two}, "ok")
  end
end
