require "./step/failure"
require "./step/success"

module Flow
  abstract class Step
    macro inherited
      include Flow::Failure
      include Flow::Success
    end

    property errors : Flow::Prop::ErrorList

    def initialize
      @errors = Flow::Prop::ErrorList.new
    end

    def []=(variable : String, value)
      {% for ivar in @type.instance_vars %}
        if {{ivar.name.stringify}} == variable
          if value.is_a?({{ ivar.type.id }})
            @{{ivar}} = value
          # elsif value.is_a?(JSON::Any)
          #   @{{ivar}} = Flow::Utils::JSON.extract_json(value, {{ ivar.type.id }})
          else
            raise "Invalid type #{value.class}"
          end
        end
      {% end %}
    end

    abstract def call : Flow::Result

    def self.call(input : Hash) : Flow::Result
      do_perform(input)
    end

    def self.call(input : Flow::Result) : Flow::Result
      self.call(input.data)
    end

    def self.from_hash(input : Hash) : Step
      new_instance = self.new
      if input
        input.each do |key, value|
          prop = properties.find { |attr| attr.has_key?(key) }

          if prop
            new_instance.validate_property(key, value, prop[key])
            new_instance[key] = value
          end
        end
      end
      new_instance
    end

    def validate_property(prop, value, options)
      return true if options.nil?
      validator = Flow::Prop::Validator(typeof(value)).new(name: prop, value: value, options: options)
      is_valid = validator.valid?
      @errors = @errors + validator.errors unless is_valid
      is_valid
    end

    def step_validation
    end

    def valid? : Bool
      step_validation
      @errors.size == 0
    end

    private def self.do_perform(input : Hash) : Flow::Result
      begin
        step_instance = from_hash(input)
        if step_instance.valid?
          result = step_instance.call
          data = result.merge_data(input).data
          is_success = result.is_success
          result_type = result.result_type
        else
          is_success = false
          result_type = "invalid_step"
          data = input.merge({"errors" => step_instance.errors.get_errors})
        end
      rescue ex
        is_success = false
        result_type = "exception"
        data = input.merge({"errors" => ex.message, "step_class" => self.to_s})
      end
      Flow::Result(typeof(data)).new(is_success, data, result_type)
    end

    private def self.properties
      {% begin %}
        {%
          has_flow_properties = @type.instance.instance_vars.select { |v| v.stringify != "errors" && v.annotation(Flow::Property) }.size
        %}

        {% if has_flow_properties > 0 %}
          props = {{ @type.instance_vars
                       .select { |ivar| ivar.annotation(Flow::Property) }
                       .map { |prop| {prop.stringify => prop.annotation(Flow::Property).named_args.empty? ? nil : prop.annotation(Flow::Property).named_args} } }}
        {% else %}
          props = [] of Hash(String, Hash(String, String))
        {% end %}
      {% end %}
    end
  end
end
