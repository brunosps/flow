class StepException < Flow::Step
  @[Flow::Property(max_length: 80)]
  property title : String = ""

  @[Flow::Property]
  property exception : Bool = false

  def call : Flow::Result
    data = {"error" => {"object" => "failure"}}
    raise Flow::FailureException.new("failure_flow", "turn off exceptions", JSON.parse(data.to_json)) if exception

    data = {"success" => {"object" => "success"}}
    Flow::Result.new(false, data, "error")
  end

  def valid!
    raise Flow::ValidationException.new("title can't be blank", {"title" => ["message array"]}) if title.empty?
  end
end
