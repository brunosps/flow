class StepException < Flow::Step
  @[Flow::Property(max_length: 80)]
  property title : String = ""

  @[Flow::Property]
  property exception : Bool = false

  def call : Flow::Result
    data = {"error" => {"object" => "failure"}}

    return failure("failure_flow", "turn off exceptions", data) if exception

    data = {"success" => {"object" => "success"}}
    success(data)
  end

  def step_validation
    errors.add("title", "title cant be blank") if title.empty?
  end
end
