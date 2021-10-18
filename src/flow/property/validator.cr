require "./error_list"

module Flow::Prop
  class Validator(U)
    DEFAULT_PARAMS = {required: false, max_length: 0, min_length: 0, size: 0, max_value: 0, min_value: 0, inclusion: [] of Hash(String, String), exclusion: [] of Hash(String, String)}

    property name : String
    property value : U
    property required : Bool
    property max_length : Int32
    property min_length : Int32
    property size : Int32
    property max_value : Int32 | Float64
    property min_value : Int32 | Float64
    property inclusion : (Array(Hash(String, String)) | Array(String)) = [] of Hash(String, String)
    property exclusion : (Array(Hash(String, String)) | Array(String)) = [] of Hash(String, String)

    def initialize(@name, @value, options = DEFAULT_PARAMS)
      @required = options.fetch(:required, false).as(Bool)
      @max_length = options.fetch(:max_length, 0).as(Int32)
      @min_length = options.fetch(:min_length, 0).as(Int32)
      @max_value = options.fetch(:max_value, 0).as(Float64 | Int32)
      @min_value = options.fetch(:min_value, 0).as(Float64 | Int32)
      @size = options.fetch(:size, 0).as(Int32)
      @inclusion = options.fetch(:inclusion, [] of Hash(String, String)).as((Array(Hash(String, String)) | Array(String)))
      @exclusion = options.fetch(:exclusion, [] of Hash(String, String)).as((Array(Hash(String, String)) | Array(String)))
    end

    def errors
      @errors ||= Flow::Prop::ErrorList.new
    end

    def validate!
      raise(errors.full_messages.join(" - ")) if !valid?
      true
    end

    def valid?
      errors.clear!
      validate
      !errors.any?
    end

    private def validate
      check_required(value)
      check_size(value)
      check_length(value)
      check_value(value)
      check_inclusion(value, inclusion)
      check_exclusion(value, exclusion)
    end

    private def check_required(value)
      errors.add(name, "is required") if required && empty?(value)
    end

    private def check_length(value)
      if value.responds_to?(:size)
        errors.add(name, "length must be greater than #{min_length}") if not_empty?(value) && min_length > 0 && value.size < min_length
        errors.add(name, "length must be less than #{max_length}") if not_empty?(value) && max_length > 0 && value.size > max_length
      elsif (min_length > 0 || max_length > 0)
        raise ArgumentError.new
      end
    end

    private def check_size(value)
      if value.responds_to?(:size)
        errors.add(name, "length must be equal to #{size}") if not_empty?(value) && size > 0 && value.size != size
      elsif size > 0
        raise ArgumentError.new
      end
    end

    private def check_value(value)
      if value.responds_to?(:to_i)
        errors.add(name, "must be greater than #{min_value}") if min_value > 0 && value.to_i < min_value
        errors.add(name, "must be less than #{max_value}") if max_value > 0 && value.to_i > max_value
      elsif (min_value > 0 || max_value > 0)
        raise ArgumentError.new
      end
    end

    private def check_inclusion(value, option_list : Array(Hash(String, String)))
      return true if option_list.empty?
      raise ArgumentError.new unless value.responds_to?(:to_s)
      list = option_list.map { |opt| opt.first_key }
      errors.add(name, "is not included in the list [#{list.join(",")}]") unless list.includes?(value.to_s)
    end

    private def check_inclusion(value, option_list : Array(String))
      return true if option_list.empty?
      raise ArgumentError.new unless value.responds_to?(:to_s)
      errors.add(name, "is not included in the list [#{option_list.join(",")}]") unless option_list.includes?(value.to_s)
    end

    private def check_exclusion(value, option_list : Array(Hash(String, String)))
      return true if option_list.empty? || !value.responds_to?(:to_s)
      list = option_list.map { |opt| opt.first_key }
      errors.add(name, "is reserved [#{list.join(",")}]") if list.includes?(value.to_s)
    end

    private def check_exclusion(value, option_list : Array(String))
      return true if option_list.empty? || !value.responds_to?(:to_s)
      errors.add(name, "is reserved [#{option_list.join(",")}]") if option_list.includes?(value.to_s)
    end

    private def empty?(value) : Bool
      case value
      when .nil?                then true
      when .is_a?(String)       then value.presence.nil?
      when .is_a?(Number)       then value == 0
      when .responds_to?(:size) then value.size == 0
      else                           false
      end
    end

    private def not_empty?(value) : Bool
      !empty?(value)
    end
  end
end
