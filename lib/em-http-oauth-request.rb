$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module EmHttpOauthRequest
  VERSION = '0.0.1'
end

require 'oauth'
require 'em-http'

module OAuth::RequestProxy::EventMachine
  class Client < OAuth::RequestProxy::Base
    # Proxy for signing Typhoeus::Request requests
    # Usage example:
    # EventMachine.run {
    #   oauth_params = {:consumer => oauth_consumer, :token => access_token}
    #   req = EventMachine::HttpRequest.new(uri).get(options)
    #   oauth_helper = OAuth::Client::Helper.new(req, oauth_params)
    #   req.options[:head] = (req.options[:head] || {}).merge!({"Authorization " => [oauth_helper.header]})
    #   req.callback {
    #     p req.response
    # 
    #     EventMachine.stop
    #   }
    # }
    #
    # NOTE: currently, em-http-request automatically base64 encodes the 'Authorization' header, which
    # breaks OAuth.  It appears that making the key of the header 'Authorization ' (note the space)
    # fixes this for the time being.
    proxies ::EventMachine::HttpClient
    
    def method
      request.method
    end
    
    def uri
      request.uri.to_s
    end
    
    def parameters
      if options[:clobber_request]
        options[:parameters]
      else
        all_parameters
      end
    end

  private

    def all_parameters
      request_params = {}
      params = post_parameters.merge(query_parameters).merge(options[:parameters] || {})
      if params
        params.each do |k,v|
          if request_params.has_key?(k)
            request_params[k] << v
          else
            request_params[k] = [v].flatten
          end
        end
      end
      request_params
    end

    def query_parameters
      request.options[:query] || {}
    end

    def post_parameters
      # Post params are only used if posting form data
      headers = request.options[:head] || {}
      if((method == 'POST' || method == 'PUT') && headers['Content-Type'] && headers['Content-Type'].downcase == 'application/x-www-form-urlencoded')
        request.options[:body] || {}
      else
        {}
      end
    end
  end
end
