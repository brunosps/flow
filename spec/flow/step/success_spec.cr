require "../../spec_helper"

describe Flow::Success do
  describe "success on Step" do
    step = StepSuccess.new
    it "responds to success" do
      step.responds_to?(:success).should be_true
    end

    it "#success only" do
      result = step.success
      result.is_success.should be_true
      result.result_type.should eq("ok")
    end

    it "#success with message" do
      result = step.success("User found at")
      result.data.has_key?("StepSuccess").should be_true
      result.data["StepSuccess"].should eq("User found at")
      result.is_success.should be_true
      result.result_type.should eq("ok")
    end

    it "#success with data" do
      result = step.success({"user_found" => true})
      result.data.has_key?("user_found").should be_true
      result.data["user_found"].should be_true
      result.is_success.should be_true
      result.result_type.should eq("ok")
    end

    it "#success with message" do
      result = step.success("User found at", {"user_found" => true})

      result.data.has_key?("StepSuccess").should be_true
      result.data["StepSuccess"].should eq("User found at")

      result.data.has_key?("user_found").should be_true
      result.data["user_found"].should be_true

      result.is_success.should be_true
      result.result_type.should eq("ok")
    end
  end
end
