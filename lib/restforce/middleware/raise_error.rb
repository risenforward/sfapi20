module Restforce
  class Middleware::RaiseError < Faraday::Response::Middleware
    def on_complete(env)
      @env = env
      case env[:status]
      when 404
        raise Faraday::Error::ResourceNotFound, message
      when 401
        raise Restforce::UnauthorizedError, message
      when 413
        raise Faraday::Error::ClientError.new("HTTP 413 - Request Entity Too Large",
                                              response_values)
      when 400...600
        raise Faraday::Error::ClientError.new(message, response_values)
      end
    end

    def message
      "#{body['errorCode']}: #{body['message']}"
    end

    def body
      @body = (@env[:body].respond_to?(:first) ? @env[:body].first : @env[:body])

      case @body
      when Hash
        @body
      else
        { 'errorCode' => '(error code missing)', 'message' => @body }
      end
    end

    def response_values
      {
        status: @env[:status],
        headers: @env[:response_headers],
        body: @env[:body]
      }
    end
  end
end
