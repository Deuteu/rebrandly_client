require 'httparty'
require 'rebrandly/configuration'
require 'rebrandly/error'

module Rebrandly
  module Client
    class << self
      API_VERSION = 'v1'.freeze
      BASE_URL = "https://api.rebrandly.com/#{API_VERSION}".freeze

      def get(end_point, options = {})
        wrap_request(end_point, options) do |url, http_options, formatted_options|
          HTTParty.get(url, http_options.merge(query: formatted_options))
        end
      end

      def post(end_point, options = {})
        wrap_request(end_point, options) do |url, http_options, formatted_options|
          HTTParty.post(url, http_options.merge(body: formatted_options.to_json))
        end
      end

      def delete(end_point, options = {})
        wrap_request(end_point, options) do |url, http_options, _formatted_options|
          HTTParty.delete(url, http_options)
        end
      end

      private

      def lower_camelize(string)
        s = string.split('_').collect(&:capitalize).join
        s[0].downcase + s[1..-1]
      end

      def underscore(string)
        string.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr('-', '_').
            downcase
      end

      def lower_camelize_keys(object)
        case object
        when Hash
          object.inject({}) do |hash, (key, value)|
            hash[lower_camelize(key.to_s).to_sym] = lower_camelize_keys(value)
            hash
          end
        when Array
          object.map do |value|
            lower_camelize_keys(value)
          end
        else
          object
        end
      end

      def underscore_keys(object)
        case object
        when Hash
          object.inject({}) do |hash, (key, value)|
            hash[underscore(key.to_s).to_sym] = underscore_keys(value)
            hash
          end
        when Array
          object.map do |value|
            underscore_keys(value)
          end
        else
          object
        end
      end

      def handle_error(response)
        parsed_response = response.parsed_response

        case response.code
        when 429
          raise RateLimitExceeded
        when 403
          raise UsageLimitExceeded.new(parsed_response['source'])
        else
          raise Error.new(parsed_response['message'])
        end
      end

      def wrap_request(end_point, options = {})
        url               = "#{BASE_URL}/#{end_point.sub(/^\//, '')}"
        http_options      = {headers: headers}
        formatted_options = lower_camelize_keys(options)

        response = yield(url, http_options, formatted_options)

        return handle_error(response) unless response.code == 200

        underscore_keys(JSON.parse(response.body))
      end

      def headers
        raise MissingApiKey unless Rebrandly.api_key

        h = Rebrandly.workspace ? {'workspace-type' => Rebrandly.workspace} : {}

        h.merge({
                    'Content-type' => 'application/json',
                    'apikey' => Rebrandly.api_key
                })
      end
    end
  end
end