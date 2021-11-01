module Flow
  class Response
    module Helpers
      def json_response(body : JSON::Any, status : HTTP::Status = HTTP::Status::OK) : Flow::Response
        @response = Flow::Response.new(body, status)
      end

      def json_response(body : (NamedTuple | Hash), status : HTTP::Status = HTTP::Status::OK) : Flow::Response
        json_response(JSON.parse(body.to_json), status)
      end

      def error_response(body : (NamedTuple | Hash), status : HTTP::Status = HTTP::Status::BAD_REQUEST) : Flow::Response
        json_response(JSON.parse(body.to_json), status)
      end

      def error_response(body : JSON::Any, status : HTTP::Status = HTTP::Status::BAD_REQUEST) : Flow::Response
        json_response(body, status)
      end

      def response_body
        @response.body
      end

      def response_status
        @response.status
      end

      def returned?
        response_body.size > 0
      end
    end

    property body : JSON::Any = JSON.parse("{}")
    property status : HTTP::Status = HTTP::Status::OK

    def initialize
      @body = JSON.parse("{}")
      @status = HTTP::Status::OK
    end

    def initialize(@body : JSON::Any, @status : HTTP::Status)
    end
  end
end
