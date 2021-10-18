require "./spec_helper"

describe Flow do
  it "works" do
    false.should eq(false)
  end

  it "check version" do
    Flow::VERSION.should eq("0.1.0")
  end
end
