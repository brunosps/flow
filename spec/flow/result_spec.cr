require "../spec_helper"

describe Flow::Result do
  input = {"one" => 1, "two" => 2}
  describe "#initialize" do
    it "new success object" do
      result = Flow::Result.new(true, input, "ok")
      result.is_success.should be_true
      result.data.should eq(input)
      result.result_type.should eq("ok")
    end

    it "new failure object" do
      result = Flow::Result(typeof(input)).new(false, input, "error")
      result.is_success.should be_false
      result.data.should eq(input)
      result.result_type.should eq("error")
    end
  end

  describe "#then" do
    it "with merges data" do
      result = StepSuccess.call(input).then(StepValidator, {"user" => "bruno"})
      result.data["user"].should eq("bruno")
    end

    it "with no merges data" do
      result = StepSuccess.call(input).then(StepValidator)
      result.data.has_key?("validator").should be_true
      result.data.has_key?("user").should be_false
    end
  end

  it "#merge_data" do
    extra = {"extra" => "extra"}

    result = Flow::Result.new(true, input, "ok")
    result = result.merge_data(extra)

    result.is_success.should be_true
    result.result_type.should eq("ok")
    result.data.has_key?("extra").should be_true
    result.data.size.should eq(3)
  end

  it "failure?" do
    result = Flow::Result.new(false, input, "ok")
    result.failure?.should be_true
  end

  it "success?" do
    result = Flow::Result.new(true, input, "ok")
    result.success?.should be_true
  end
end
