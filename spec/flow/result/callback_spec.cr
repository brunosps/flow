require "../../spec_helper"

describe "Flow::Callback" do
  describe "#on_success" do
    data = {"one" => 1, "two" => 2}

    it "respond to on_success" do
      result = Flow::Result.new(true, data, "ok")
      result.responds_to?(:on_success).should be_true
    end

    it "exec block on_success" do
      result = Flow::Result.new(true, data, "ok")
      result_data = {"result" => "OK"}
      response = result
        .on_failure do |res|
          pp "on_failure"
          res.error_response({"error" => res.data})
        end
        .on_success do |res|
          res.json_response(result_data)
        end

      response.returned?.should be_true
      response.response_status.should eq(HTTP::Status::OK)
      response.response_body.as_h.should eq(result_data)
    end

    it "exec proc on_success" do
      result = Flow::Result.new(true, data, "ok")
      response = result
        .on_failure { |res| res.error_response({"error" => res.data}) }
        .on_success { |res| res.json_response(res.data) }
      response.returned?.should be_true
      response.response_status.should eq(HTTP::Status::OK)
      response.response_body.as_h.should eq(data)
    end
  end

  describe "#on_failure" do
    data = {"user_not_found" => true}
    it "respond to on_failure" do
      result = Flow::Result.new(false, data, "custom_fail_type")
      result.responds_to?(:on_failure).should be_true
    end

    it "exec proc on_failure" do
      result = Flow::Result.new(false, data, "custom_fail_type")
      response = result
        .on_failure { |res| res.error_response({"error" => "User not found"}) }
        .on_success { |res| res.json_response(res.data) }

      response.returned?.should be_true
      response.response_status.should eq(HTTP::Status::BAD_REQUEST)

      response.response_body.as_h.should eq({"error" => "User not found"})
    end

    it "exec proc on_failure with result_type(String)" do
      result = Flow::Result.new(false, data, "custom_fail_type")
      response = result
        .on_failure("custom_fail_type") { |res| res.error_response({"error" => "Custom error"}) }
        .on_failure { |res| res.error_response({"error" => "User not found"}) }
        .on_success { |res| res.json_response(res.data) }

      response.returned?.should be_true
      response.response_status.should eq(HTTP::Status::BAD_REQUEST)
      response.result_type.should eq("custom_fail_type")
      response.response_body.as_h.should eq({"error" => "Custom error"})
    end

    it "exec proc on_failure with result_type(Array(String))" do
      result = Flow::Result.new(false, data, "fail_type")
      response = result
        .on_failure(["custom_fail_type", "fail_type"]) { |res| res.error_response({"error" => "Fail Type"}) }
        .on_failure { |res| res.error_response({"error" => "User not found"}) }
        .on_success { |res| res.json_response(res.data) }

      response.returned?.should be_true
      response.result_type.should eq("fail_type")
      response.response_status.should eq(HTTP::Status::BAD_REQUEST)

      response.response_body.as_h.should eq({"error" => "Fail Type"})
    end

    it "exec proc on_failure with *result_type" do
      result = Flow::Result.new(false, data, "fail_type")
      response = result
        .on_failure("custom_fail_type", "fail_type") { |res| res.error_response({"error" => "Fail Type"}) }
        .on_failure { |res| res.error_response({"error" => "User not found"}) }
        .on_success { |res| res.json_response(res.data) }

      response.returned?.should be_true
      response.result_type.should eq("fail_type")
      response.response_status.should eq(HTTP::Status::BAD_REQUEST)

      response.response_body.as_h.should eq({"error" => "Fail Type"})
    end
  end

  it "#on_exception" do
    response = StepFailure.call({"one" => 1, "two" => 0})
      .on_failure { |res| res.error_response({"error" => "User not found"}) }
      .on_success { |res| res.json_response(res.data) }
      .on_exception { |res| res.error_response(res.data.merge({"exception" => true, "message" => "Exception"})) }

    response.returned?.should be_true
    response.result_type.should eq("exception")
    response.response_status.should eq(HTTP::Status::BAD_REQUEST)

    response.response_body.as_h.dig("message").should eq("Exception")
  end
end
