require "../spec_helper"

class ActiveFlowTest < Flow::ActiveFlow
  step ValidateEmailStep
end

describe Flow::ActiveFlow do
  describe "Static Call" do
    it "call with invalid parameter" do
      input = {"name" => "Bruno", "email" => ""}
      result = ActiveFlowTest.call(input)

      result.data.dig("errors", "email").should eq("is required")
      result.is_success.should be_false
    end

    it "call with valid parameter" do
      input = {"name" => "Bruno", "email" => "bruno@bruno.com"}
      result = ActiveFlowTest.call(input)

      # result.data["email"].value.should eq("bruno@bruno.com")
      result.is_success.should be_true
    end
  end
end
