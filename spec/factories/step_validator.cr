class StepValidator < Flow::Step
  @[Flow::Property(required: true)]
  property required_prop : Int32?

  @[Flow::Property(max_length: 10)]
  property max_length_prop_int : Int32?

  @[Flow::Property(max_length: 10)]
  property max_length_prop_str : String?

  @[Flow::Property(min_length: 10)]
  property min_length_prop_int : Int32?

  @[Flow::Property(min_length: 10)]
  property min_length_prop_str : String?

  @[Flow::Property(max_value: 10)]
  property max_value_prop_int : Int32?

  @[Flow::Property(max_value: 10)]
  property max_value_prop_str : String?

  @[Flow::Property(min_value: 10)]
  property min_value_prop_int : Int32?

  @[Flow::Property(min_value: 10)]
  property min_value_prop_str : String?

  @[Flow::Property(inclusion: [{"AT", "Automatic"}, {"MN", "Manual"}])]
  property inclusion_prop_str : String?

  @[Flow::Property(exclusion: [{"AT", "Automatic"}, {"MN", "Manual"}])]
  property exclusion_prop_str : String?

  def call : Flow::Result
    Flow::Result.new(true, {"one" => one, "two" => two}, "ok")
  end
end
