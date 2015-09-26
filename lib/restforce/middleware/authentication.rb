module Restforce

  # Faraday middleware that allows for on the fly authentication of requests.
  # When a request fails (ie. A status of 401 is returned). The middleware
  # will attempt to either reauthenticate (username and password) or refresh
  # the oauth access token (if a refresh token is present).
  class Middleware::Authentication < Restforce::Middleware
    autoload :Password, 'restforce/middleware/authentication/password'
    autoload :Token,    'restforce/middleware/authentication/token'

    def call(env)
      @app.call(env)
    rescue Restforce::UnauthorizedError
      authenticate!
      raise
    end

    def authenticate!
      response = connection.post '/services/oauth2/token' do |req|
        req.body = URI.encode_www_form params
      end
      raise Restforce::AuthenticationError, error_message(response) if response.status != 200
      @options[:instance_url] = response.body['instance_url']
      @options[:oauth_token]  = response.body['access_token']
      response.body
    end

    def params
      raise 'not implemented'
    end

    def connection
      @connection ||= Faraday.new(:url => "https://#{@options[:host]}") do |builder|
        builder.use Restforce::Middleware::Mashify, nil, @options
        builder.response :json
        builder.use Restforce::Middleware::Logger, Restforce.configuration.logger, @options if Restforce.log?
        builder.adapter Faraday.default_adapter
      end
    end

    def error_message(response)
      "#{response.body['error']}: #{response.body['error_description']}"
    end
  
  end

end
