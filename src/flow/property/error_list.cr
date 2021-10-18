require "./error"

module Flow::Prop
  class ErrorList
    def initialize
      @errors = Array(Flow::Prop::Error).new
    end

    def any?
      !@errors.empty?
    end

    def add(prop : String, message : String)
      if self[prop].empty?
        @errors << Flow::Prop::Error.new(prop, message)
      else
        self[prop].first << message
      end
    end

    def add(err : Flow::Prop::Error)
      err.messages.each do |message|
        add(err.name, message)
      end
    end

    def [](prop)
      @errors.select { |error| error.name == prop } || [] of Flow::Prop::Error
    end

    def messages(prop)
      (self[prop].size > 0 ? self[prop].first.messages : [] of String)
    end

    def clear!
      @errors.clear
    end

    def full_messages
      @errors.map do |err|
        err.to_s
      end
    end

    def size
      @errors.size
    end

    def each
      @errors.each do |error|
        yield error
      end
    end

    def +(error_list : Flow::Prop::ErrorList)
      new_list = Flow::Prop::ErrorList.new
      @errors.each do |err|
        new_list.add(err)
      end
      error_list.each do |err|
        new_list.add(err)
      end
      new_list
    end
  end
end
