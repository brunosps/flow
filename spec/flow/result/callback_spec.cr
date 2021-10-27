require "../../spec_helper"

describe Flow::Callback do
  describe "#on_success" do
    result = Flow::Result.new(true, {"one" => 1, "two" => 2}, "ok")
    it "respond to on_success" do
      result.responds_to?(:on_success).should be_true
    end

    it "exec block on_success" do
      response = result.on_success do |res|
        pp! res
      end
    end
  end
end
