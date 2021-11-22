require "../spec_helper"

describe Flow::Step do
  describe "Flow::Step.call" do
    it "respond to self.call" do
      StepSuccess.responds_to?(:call).should be_true
    end

    describe "test result with Hash" do
      input = {"one" => 1, "two" => 2}
      it "when success" do
        result = StepSuccess.call(input)
        result.is_a?(Flow::Result).should be_true
        result.is_success.should be_true
        result.data.should eq(input)
        result.result_type.should eq("ok")
      end

      it "when failure" do
        result = StepFailure.call(input)

        result.is_a?(Flow::Result).should be_true
        result.data.has_key?("one").should be_true

        result.data.has_key?("errors").should be_true
        result.data["errors"].as(Hash).has_key?("division_product").should be_true
        result.result_type.should eq("error")
      end
    end

    describe "test result with Flow::Result" do
      input = {"one" => 1, "two" => 2}
      initial_result = Flow::Result.new(true, input, "ok")
      it "when success" do
        result = StepSuccess.call(initial_result)
        result.is_a?(Flow::Result).should be_true
        result.is_success.should be_true
        result.data.should eq(input)
        result.result_type.should eq("ok")
      end

      it "when failure" do
        result = StepFailure.call(initial_result)
        result.is_a?(Flow::Result).should be_true
        result.is_success.should be_false
        result.data.has_key?("one").should be_true
        result.data.has_key?("errors").should be_true
        result.data["errors"].as(Hash).has_key?("division_product").should be_true

        result.result_type.should eq("error")
      end
    end
  end

  describe "#[]=" do
    input = {"one" => 1, "two" => 2}

    it "change value" do
      step = StepSuccess.from_hash(input)
      step.one.should eq(1)
      step["one"] = 2
      step.one.should eq(2)
    end
  end

  describe "#from_hash" do
    it "load data from hash to step instance" do
      input = {"one" => 1, "two" => 2}
      step = StepSuccess.from_hash(input)

      step.is_a?(Flow::Step).should be_true
      step.one.should eq(1)
      step.two.should eq(2)
    end
  end

  describe "#call" do
    step1 = StepSuccess.new
    it "respond to #call" do
      step1.responds_to?(:call).should be_true
    end

    it "check result type" do
      (step1.call).is_a?(Flow::Result).should be_true
    end
  end

  describe "complex test with objects and result#then" do
    it "valid data" do
      input = {"name" => "Bruno", "email" => "bruno@bruno.com"}
      result = ValidateEmailStep.call(input)
        .then(CreateUserStep)
        .then(SerializeUserStep)
        .then(SendMailStep)

      result.success?.should be_true
      result.data.has_key?("user").should be_true
    end

    it "invalid data" do
      input = {"name" => "Bruno", "email" => "brunobruno.com"}
      result = ValidateEmailStep.call(input)
        .then(CreateUserStep)
        .then(SerializeUserStep)
        .then(SendMailStep)
      result.success?.should be_false
      result.data.has_key?("errors").should be_true
      result.data.dig("errors", "message").should eq("Email is not valid!")
    end

    it "invalid property" do
      input = {"name" => "Bruno", "email" => ""}
      result = ValidateEmailStep.call(input)
        .then(CreateUserStep)
        .then(SerializeUserStep)
        .then(SendMailStep)

      result.success?.should be_false
      result.result_type.should eq("invalid_step")
      result.data.has_key?("errors").should be_true
      result.data.dig("errors", "email").should eq("is required")
    end
  end
end
