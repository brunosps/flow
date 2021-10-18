require "./spec_helper"

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
        result.data.has_key?("division_product").should be_true
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
        result.data.has_key?("division_product").should be_true
        result.result_type.should eq("error")
      end
    end

    describe "test exceptions" do
      it "Flow::ValidationException" do
        # expect_raises(Flow::ValidationException) do
        #   StepException.call({"title" => ""})
        # end
        result = StepException.call({"title" => ""})
        result.is_success.should be_false
        result.result_type.should eq("invalid_attributes")
        result.data.has_key?("errors").should be_true
      end

      it "Flow::FailureException" do
        #   expect_raises(Flow::FailureException) do
        #   end
        result = StepException.call({"title" => "Title", "exception" => true})
        result.is_success.should be_false
        result.result_type.should eq("failure_flow")
        result.data.has_key?("errors").should be_true
      end

      it "Flow::Exception" do
        #   expect_raises(Flow::FailureException) do
        #   end
        result = StepFailure.call({"one" => 4, "two" => 0})
        result.is_success.should be_false
        result.result_type.should eq("exception")
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
end
