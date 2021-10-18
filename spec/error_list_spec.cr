require "./spec_helper"

describe Flow::Prop::ErrorList do
  it "#add with message" do
    error_list = Flow::Prop::ErrorList.new
    error_list.add("attr", "message")
    error_list.messages("attr").includes?("message").should be_true
  end

  it "#add with Flow::Prop::Error" do
    error_list = Flow::Prop::ErrorList.new
    error = Flow::Prop::Error.new("attr", "error")
    error_list.add(error)
    error_list.messages("attr").includes?("error").should be_true
  end

  it "#any?" do
    error_list = Flow::Prop::ErrorList.new

    error_list.any?.should be_false
    error_list.add("attr", "message")
    error_list.any?.should be_true
  end

  it "#[]" do
    error_list = Flow::Prop::ErrorList.new
    error = Flow::Prop::Error.new("attr", "error")
    error_list.add(error)
    error_list["attr"].first.messages.should eq(error.messages)
  end

  it "#messages" do
    error_list = Flow::Prop::ErrorList.new
    error_list.messages("attr").should be_a(Array(String))
    error_list.messages("attr").size.should eq(0)
    error_list.add("attr", "message")
    error_list.messages("attr").size.should eq(1)
  end

  it "#clear!" do
    error_list = Flow::Prop::ErrorList.new
    error_list.add("attr", "message")
    error_list.any?.should be_true
    error_list.clear!
    error_list.any?.should be_false
  end

  it "#full_messages" do
    error_list = Flow::Prop::ErrorList.new
    error_list.add("attr", "message")
    error_list.add("attr", "errors")
    error_list.full_messages.should eq(["attr: message, errors"])
  end

  it "#size" do
    error_list = Flow::Prop::ErrorList.new
    error_list.add("attr1", "message")
    error_list.add("attr2", "errors")
    error_list.size.should eq(2)
  end

  it "#+" do
    error_list1 = Flow::Prop::ErrorList.new
    error_list1.add("attr1", "message")

    error_list2 = Flow::Prop::ErrorList.new
    error_list2.add("attr2", "errors")

    error_list = error_list1 + error_list2

    error_list.size.should eq(2)
    error_list.full_messages.should eq(["attr1: message", "attr2: errors"])
  end
end
