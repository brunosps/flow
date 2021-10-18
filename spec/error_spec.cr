require "./spec_helper"

describe Flow::Prop::Error do
  describe "#initialize" do
    it "with String" do
      error = Flow::Prop::Error.new("attr", "error")
      error.messages.size.should eq(1)
      error.messages.first.should eq("error")
    end

    it "with Array(String)" do
      error = Flow::Prop::Error.new("attr", ["error", "on", "attr"])
      error.messages.size.should eq(3)
      error.messages.first.should eq("error")
      error.messages.last.should eq("attr")
    end
  end

  describe "#<<" do
    it "Add a new string to messages" do
      error = Flow::Prop::Error.new("attr", "error")
      error.messages.size.should eq(1)

      error << "test"

      error.messages.size.should eq(2)
      error.messages.last.should eq("test")
    end
  end

  describe "#to_s" do
    it "to string" do
      error = Flow::Prop::Error.new("attr", "error")
      error.messages.size.should eq(1)
      error.to_s.should eq("attr: error")

      error << "test"

      error.messages.size.should eq(2)
      error.messages.last.should eq("test")
      error.to_s.should eq("attr: error, test")
    end
  end
end
