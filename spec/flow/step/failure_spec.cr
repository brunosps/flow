require "../../spec_helper"

describe Flow::Failure do
  describe "failure on Step" do
    step = StepSuccess.new

    it "responds to failure" do
      step.responds_to?(:failure).should be_true
    end

    it "failure with message" do
      result = step.failure("error message")

      result.data.has_key?("errors").should be_true
      result.data["errors"]["message"].should eq("error message")

      result.is_success.should be_false
      result.result_type.should eq("error")
    end

    it "failure with type and message" do
      result = step.failure("fail_type", "error message")

      result.data.has_key?("errors").should be_true
      result.data["errors"]["message"].should eq("error message")

      result.is_success.should be_false
      result.result_type.should eq("fail_type")
    end

    it "failure with type and data" do
      result = step.failure("user_not_found", {"user_found" => false})

      result.data.has_key?("errors").should be_true
      result.data["errors"]["message"].should eq("user_not_found")
      result.data["errors"]["user_found"].should be_false
      result.is_success.should be_false
      result.result_type.should eq("user_not_found")
    end

    it "failure with type, message and data" do
      result = step.failure("user_not_found", "User not found", {"user_found" => false})

      result.data.has_key?("errors").should be_true
      result.data["errors"]["message"].should eq("User not found")
      result.data["errors"]["user_found"].should be_false
      result.is_success.should be_false
      result.result_type.should eq("user_not_found")
    end
  end
end
