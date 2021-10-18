module Flow::Prop
  class Error
    property name : String
    property messages : Array(String)

    def initialize(@name : String, messages : Array(String))
      @messages = messages
    end

    def initialize(@name : String, messages : String)
      @messages = [messages]
    end

    def <<(message : String)
      @messages << message
    end

    def to_s
      "#{@name}: #{messages.join(", ")}"
    end
  end
end
