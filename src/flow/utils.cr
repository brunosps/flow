module Flow
  module Utils
    class MergeParams(T)
      def initialize(@params : T)
      end

      def merge(other : U) forall U
        # new_params : typeof(other, @params) = @params.dup
        new_params = {} of String => String

        other.each do |k, v|
          new_params = new_params.merge({k => v})
        end

        @params.each do |k, v|
          new_params = new_params.merge({k => v})
        end

        new_params
      end
    end

    class JSON
      def self.extract_json(value : ::JSON::Any, type : (Array | Nil).class)
        value.as_a
      end

      def self.extract_json(value : ::JSON::Any, type : (Bool | Nil).class)
        value.as_bool
      end

      def self.extract_json(value : ::JSON::Any, type : (Float64 | Nil).class)
        value.as_f
      end

      def self.extract_json(value : ::JSON::Any, type : (Float32 | Nil).class)
        value.as_f32
      end

      def self.extract_json(value : ::JSON::Any, type : (Hash | Nil).class)
        value.as_h
      end

      def self.extract_json(value : ::JSON::Any, type : (Int32 | Nil).class)
        value.as_i
      end

      def self.extract_json(value : ::JSON::Any, type : (Int64 | Nil).class)
        value.as_i64
      end

      def self.extract_json(value : ::JSON::Any, type : (String | Nil).class)
        value.as_s
      end

      def self.extract_json(value : ::JSON::Any, type : (U | Nil).class) forall U
        JSON.parse(value.to_json)
      end
    end
  end
end
