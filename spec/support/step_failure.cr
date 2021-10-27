class StepFailure < Flow::Step
  @[Flow::Property(required: true)]
  property one : Int32?

  @[Flow::Property]
  property two : Int32?

  def call : Flow::Result
    result = (one.not_nil! / two.not_nil!).to_i

    Flow::Result.new(false, {"division_product" => result}, "error")
  end
end
