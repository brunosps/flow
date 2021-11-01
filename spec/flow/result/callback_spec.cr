require "../../spec_helper"

describe Flow::Callback do
  describe "#on_failure" do
    data = {"user_not_found" => true}

    it "respond to on_failure" do
      result = Flow::Result.new(false, data, "custom_fail_type")
      result.responds_to?(:on_failure).should be_true
    end

    describe "from result" do
      it "on failure with proc" do
        result = Flow::Result.new(false, data, "custom_fail_type")
          .on_success { |res| res.json_response(res.data) }
          .on_failure { |res| res.error_response({"error" => "User not found"}) }

        result.result_type.should eq("custom_fail_type")
        result.is_success.should be_false
        result.response_status.should eq(HTTP::Status::BAD_REQUEST)
      end

      it "on failure with block" do
        result = Flow::Result.new(false, data, "custom_fail_type")
          .on_success do |res|
            res.json_response(res.data)
          end
          .on_failure do |res|
            res.error_response({"error" => "User not found"})
          end
        result.result_type.should eq("custom_fail_type")
        result.is_success.should be_false
        result.response_status.should eq(HTTP::Status::BAD_REQUEST)
      end
    end

    describe "from step" do
      it "on failure with block" do
        response = StepFailure.call({"one" => 1, "two" => 1})
          .on_success { |res| res.json_response(res.data) }
          .on_failure { |res| res.error_response({"error" => "User not found"}) }
      end

      it "on failure with block" do
        step = StepFailure.from_hash({"one" => 1, "two" => 1})
        response = step.call
          .on_success { |res| res.json_response(res.data) }
          .on_failure { |res| res.error_response({"error" => "User not found"}) }
      end
    end
  end

  # describe "#on_success" do
  #   data = {"one" => 1, "two" => 2}

  #   it "respond to on_success" do
  #     result = Flow::Result.new(true, data, "ok")
  #     result.responds_to?(:on_success).should be_true
  #   end

  #   it "exec block on_success" do
  #     result = Flow::Result.new(true, data, "ok")
  #     response = result
  #       .on_failure do |res|
  #         pp "on_failure"
  #         pp! res
  #         # res.error_response({"error" => res.data})
  #       end
  #       .on_success do |res|
  #         pp! res
  #         # res.json_response(res.data)
  #       end

  #     response.returned?.should be_true
  #     response.response_status.should eq(HTTP::Status::OK)
  #     response.response_body.as_h.should eq(data)
  #   end

  #   it "exec proc on_success" do
  #     result = Flow::Result.new(true, data, "ok")
  #     # response = result
  #     #   .on_failure { |res| res.error_response({"error" => res.data}) }
  #     #   .on_success { |res| res.json_response(res.data) }
  #     # response.returned?.should be_true
  #     # response.response_status.should eq(HTTP::Status::OK)
  #     # response.response_body.as_h.should eq(data)
  #   end
  # end

  # describe "#on_failure" do
  #   data = {"user_not_found" => true}
  #   it "respond to on_failure" do
  #     result = Flow::Result.new(false, data, "custom_fail_type")
  #     result.responds_to?(:on_failure).should be_true
  #   end

  #   it "exec proc on_failure" do
  #     result = Flow::Result.new(false, data, "custom_fail_type")
  #     # response = result
  #     #   .on_failure { |res| res.error_response({"error" => "User not found"}) }
  #     #   .on_success { |res| res.json_response(res.data) }

  #     # response.returned?.should be_true
  #     # response.response_status.should eq(HTTP::Status::BAD_REQUEST)

  #     # response.response_body.as_h.should eq({"error" => "User not found"})
  #   end

  #   it "exec proc on_failure with result_type(String)" do
  #     result = Flow::Result.new(false, data, "custom_fail_type")
  #     # response = result
  #     #   .on_failure("custom_fail_type") { |res| res.error_response({"error" => "Custom error"}) }
  #     #   .on_failure { |res| res.error_response({"error" => "User not found"}) }
  #     #   .on_success { |res| res.json_response(res.data) }

  #     # response.returned?.should be_true
  #     # response.response_status.should eq(HTTP::Status::BAD_REQUEST)
  #     # response.result_type.should eq("custom_fail_type")
  #     # response.response_body.as_h.should eq({"error" => "Custom error"})
  #   end

  #   it "exec proc on_failure with result_type(Array(String))" do
  #     result = Flow::Result.new(false, data, "fail_type")
  #     # response = result
  #     #   .on_failure(["custom_fail_type", "fail_type"]) { |res| res.error_response({"error" => "Fail Type"}) }
  #     #   .on_failure { |res| res.error_response({"error" => "User not found"}) }
  #     #   .on_success { |res| res.json_response(res.data) }

  #     # response.returned?.should be_true
  #     # response.result_type.should eq("fail_type")
  #     # response.response_status.should eq(HTTP::Status::BAD_REQUEST)

  #     # response.response_body.as_h.should eq({"error" => "Fail Type"})
  #   end

  #   it "exec proc on_failure with *result_type" do
  #     result = Flow::Result.new(false, data, "fail_type")
  #     # response = result
  #     #   .on_failure("custom_fail_type", "fail_type") { |res| res.error_response({"error" => "Fail Type"}) }
  #     #   .on_failure { |res| res.error_response({"error" => "User not found"}) }
  #     #   .on_success { |res| res.json_response(res.data) }

  #     # response.returned?.should be_true
  #     # response.result_type.should eq("fail_type")
  #     # response.response_status.should eq(HTTP::Status::BAD_REQUEST)

  #     # response.response_body.as_h.should eq({"error" => "Fail Type"})
  #   end
  # end

  # it "#on_exception" do
  #   result = StepFailure.call({"one" => 1, "two" => 1})
  #   #         .on_failure { |res| res.error_response({"error" => "User not found"}) }
  #   # .on_failure { |res| res.error_response({"error" => "User not found"}) }
  #   # .on_success { |res| res.json_response(res.data) }
  #   # .on_exception { |res| res.error_response({"exception" => true, "message" => res.data["error"]["message"]}) }
  #   pp! result
  #   pp! typeof(result)
  # end
end
