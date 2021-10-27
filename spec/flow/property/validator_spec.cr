require "../../spec_helper"

describe Flow::Prop::Validator do
  input = {
    name:  "attr",
    value: "test",
  }

  it "#initialize" do
    validator = Flow::Prop::Validator(String).new(**input)
    validator.errors.should be_a(Flow::Prop::ErrorList)
  end

  # TYPES = [Nil, String, Bool, Int32, Int64, Float32, Float64, Time, Bytes]

  describe "Validates String" do
    it "required" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: ""}), options: {required: true})
      validator.required.should be_true
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is required").should be_true
    end

    it "max length" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"}), options: {max_length: 10})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("length must be less than 10").should be_true
    end

    it "min length" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "L"}), options: {min_length: 2})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("length must be greater than 2").should be_true
    end

    it "size" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "Lorem"}), options: {size: 10})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("length must be equal to 10").should be_true
    end

    it "max value" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "50"}), options: {max_value: 40})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be less than 40").should be_true
    end

    it "max value with invalid value" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "Lorem"}), options: {max_value: 40})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "min value" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "50"}), options: {min_value: 60})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be greater than 60").should be_true
    end

    it "min value with invalid value" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "Lorem"}), options: {min_value: 40})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "inclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "BS1"}), options: {size: 3, inclusion: [{"BSB" => "Brasília"}, {"CGH" => "Congonhas"}]})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [BSB,CGH]").should be_true
    end

    it "inclusion with [] of String" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "BS1"}), options: {inclusion: ["BSB", "CGH"]})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [BSB,CGH]").should be_true
    end

    it "exclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "BSB"}), options: {size: 3, exclusion: [{"BSB" => "Brasília"}, {"CGH" => "Congonhas"}]})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is reserved [BSB,CGH]").should be_true
    end

    it "exclusion with [] of String" do
      validator = Flow::Prop::Validator(String).new(**input.merge({value: "CGH"}), options: {exclusion: ["BSB", "CGH"]})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is reserved [BSB,CGH]").should be_true
    end
  end

  describe "Validates Bool" do
    it "required" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {required: true})
      validator.required.should be_true
      validator.valid?.should be_true
    end

    it "max length" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {max_length: 10})
      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "min length" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {min_length: 10})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "size" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {size: 10})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "max value" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {max_value: 40})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "min value" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {min_value: 60})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "inclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {inclusion: [{"false" => "False"}]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [false]").should be_true
    end

    it "inclusion with [] of String" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: true}), options: {inclusion: ["false"]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [false]").should be_true
    end

    it "exclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: false}), options: {exclusion: [{"false" => "False"}]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is reserved [false]").should be_true
    end

    it "exclusion with [] of String" do
      validator = Flow::Prop::Validator(Bool).new(**input.merge({value: false}), options: {exclusion: ["false"]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is reserved [false]").should be_true
    end
  end

  describe "Validates Int32" do
    it "required" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 0}), options: {required: true})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is required").should be_true
    end

    it "max length" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 42}), options: {max_length: 10})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "min length" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 42}), options: {min_length: 2})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "size" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 42}), options: {size: 10})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "max value" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 50}), options: {max_value: 40})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be less than 40").should be_true
    end

    # it "max value with invalid value" do
    #   validator = Flow::Prop::Validator(Int32).new(**input.merge({value: nil, max_value: 40}))

    #   expect_raises(ArgumentError) do
    #     validator.valid?.should be_false
    #   end
    # end

    it "min value" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 50}), options: {min_value: 60})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be greater than 60").should be_true
    end

    # it "min value with invalid value" do
    #   validator = Flow::Prop::Validator(String).new(**input.merge({value: "Lorem", min_value: 40}))

    #   expect_raises(ArgumentError) do
    #     validator.valid?.should be_false
    #   end
    # end

    it "inclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 3}), options: {inclusion: [{"1" => "First"}, {"2" => "Second"}]})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [1,2]").should be_true
    end

    it "inclusion with [] of String" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 3}), options: {inclusion: ["1", "2"]})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [1,2]").should be_true
    end

    it "exclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 2}), options: {exclusion: [{"1" => "First"}, {"2" => "Second"}]})

      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is reserved [1,2]").should be_true
    end

    it "exclusion with [] of String" do
      validator = Flow::Prop::Validator(Int32).new(**input.merge({value: 2}), options: {exclusion: ["1", "2"]})

      validator.valid?.should be_false

      validator.errors.messages("attr").includes?("is reserved [1,2]").should be_true
    end
  end

  describe "Validates Float64" do
    it "required" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 0.0}), options: {required: true})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is required").should be_true
    end

    it "max length" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 42.5}), options: {max_length: 10})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "min length" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 42.5}), options: {min_length: 2})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "size" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 42.5}), options: {size: 10})

      expect_raises(ArgumentError) do
        validator.valid?.should be_false
      end
    end

    it "max value Int32" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 50.5}), options: {max_value: 40})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be less than 40").should be_true
    end

    it "max value Float64" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 50.5}), options: {max_value: 40.5})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be less than 40.5").should be_true
    end

    # it "max value with invalid value" do
    #   validator = Flow::Prop::Validator(Float64).new(**input.merge({value: nil, max_value: 40}))

    #   expect_raises(ArgumentError) do
    #     validator.valid?.should be_false
    #   end
    # end

    it "min value Int32" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 50.5}), options: {min_value: 60})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be greater than 60").should be_true
    end

    it "min value Float64" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 50.5}), options: {min_value: 60.5})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("must be greater than 60.5").should be_true
    end

    # it "min value with invalid value" do
    #   validator = Flow::Prop::Validator(String).new(**input.merge({value: "Lorem", min_value: 40}))

    #   expect_raises(ArgumentError) do
    #     validator.valid?.should be_false
    #   end
    # end

    it "inclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 3.5}), options: {inclusion: [{"1" => "First"}, {"2" => "Second"}, {"1.5" => "One a half"}]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [1,2,1.5]").should be_true
    end

    it "inclusion with [] of String" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 3.5}), options: {inclusion: ["1", "2", "1.5"]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is not included in the list [1,2,1.5]").should be_true
    end

    it "exclusion with [] of Hash(String, String)" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 2.5}), options: {exclusion: [{"1" => "First"}, {"2.5" => "Second"}]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is reserved [1,2.5]").should be_true
    end

    it "exclusion with [] of String" do
      validator = Flow::Prop::Validator(Float64).new(**input.merge({value: 2.5}), options: {exclusion: ["1", "2.5"]})
      validator.valid?.should be_false
      validator.errors.messages("attr").includes?("is reserved [1,2.5]").should be_true
    end
  end
end
