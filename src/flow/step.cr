require "./step/failure"
require "./step/success"

module Flow
  abstract class Step
    macro inherited
      include Flow::Failure
      include Flow::Success
    end

    def []=(variable : String, value)
      {% for ivar in @type.instance_vars %}
        if {{ivar.name.stringify}} == variable
          if value.is_a?({{ ivar.type.id }})
            @{{ivar}} = value
          elsif value.is_a?(JSON::Any)
            @{{ivar}} = Flow::Utils::JSON.extract_json(value, {{ ivar.type.id }})
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

          if prop && validate_property(key, value, prop[key])
            new_instance[key] = value
          end
        end
      end
      new_instance
    end

    def self.validate_property(prop, value, options)
      return true if options.nil?
      validator = Flow::Prop::Validator(typeof(value)).new(name: prop, value: value, options: options)
      validator.validate!
    end

    def valid! : Void
    end

    private def self.do_perform(input : Hash) : Flow::Result
      begin
        step_instance = from_hash(input)
        step_instance.valid!
        result = step_instance.call
        result.merge_data(input)
        is_success = result.is_success
        data = result.data
        result_type = result.result_type
      rescue ex : Flow::ValidationException
        is_success = false
        data = {"errors" => {
          "data"    => ex.data,
          "type"    => "Flow::ValidationException",
          "message" => ex.message.not_nil!,
        }}
        result_type = "invalid_attributes"
      rescue ex : Flow::FailureException
        is_success = false
        data = {"errors" => {
          "data"    => ex.data,
          "type"    => "Flow::FailureException",
          "message" => ex.message.not_nil!,
        }}
        result_type = ex.failure_type
      rescue ex : Exception
        is_success = false
        data = {"errors" => {"type" => "Exception", "message" => ex.message.not_nil!}}
        result_type = "exception"
      end
      Flow::Result(typeof(data)).new(is_success, data, result_type)
    end

    private def self.properties
      {% begin %}
        {% if @type.instance.instance_vars.size > 0 %}
          props = {{ @type.instance_vars
                       .select { |ivar| ivar.annotation(Flow::Property) }
                       .map { |prop| {prop.stringify => prop.annotation(Flow::Property).named_args.empty? ? nil : prop.annotation(Flow::Property).named_args} } }}
        {% else %}
          props = [] of String
        {% end %}
      {% end %}
    end
  end
end
