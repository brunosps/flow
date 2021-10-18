module Flow
  module Utils
    class JSON
      def self.extract_json(value : JSON::Any, type : (Array | Nil).class)
        value.as_a
      end

      def self.extract_json(value : JSON::Any, type : (Bool | Nil).class)
        value.as_bool
      end

      def self.extract_json(value : JSON::Any, type : (Float64 | Nil).class)
        value.as_f
      end

      def self.extract_json(value : JSON::Any, type : (Float32 | Nil).class)
        value.as_f32
      end

      def self.extract_json(value : JSON::Any, type : (Hash | Nil).class)
        value.as_h
      end

      def self.extract_json(value : JSON::Any, type : (Int32 | Nil).class)
        value.as_i
      end

      def self.extract_json(value : JSON::Any, type : (Int64 | Nil).class)
        value.as_i64
      end

      def self.extract_json(value : JSON::Any, type : (String | Nil).class)
        value.as_s
      end

      def extract_json(value : JSON::Any, type : (U | Nil).class) forall U
        JSON.parse(value.to_json)
      end
    end
  end
end
