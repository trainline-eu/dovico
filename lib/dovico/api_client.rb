require 'typhoeus'
require 'json'

module Dovico
  class ApiClient
    API_URL = "https://api.dovico.com/"
    API_VERSION = "5"

    class << self
      def initialize!(client_token, user_token)
        @client_token = client_token
        @user_token = user_token
      end

      def get(path, params: {})
        perform!(:get, path, params: params)
      end

      def post(path, params: {}, body: nil)
        perform!(:post, path, params: params, body: body)
      end

      def put(path, params: {}, body: nil)
        perform!(:put, path, params: params, body: body)
      end

      def delete(path, params: {}, body: nil)
        perform!(:delete, path, params: params, body: body)
      end

      private

      attr_accessor :client_token, :user_token

      def authorization_token
        "WRAP access_token=\"client=#{client_token}&user_token=#{user_token}\""
      end

      def request_headers
        {
          "Accept"        => "application/json",
          "Content-Type"  => "application/json",
          "Authorization" => authorization_token,
        }
      end

      def perform!(method, path, params: {}, body: nil)
        request = Typhoeus::Request.new(
          "#{API_URL}#{path}",
          method: method,
          params: params.merge(version: API_VERSION),
          headers: request_headers,
          body: body,
        )

        response = request.run

        if response.code != 200
          response = JSON.parse(response.body)
          puts "== Error during HTTP request =="
          puts "Status:      #{response["Status"]}"
          puts "Description: #{response["Description"]}"
          puts ""
          raise "Error during HTTP request"
        end

        if response.body.length > 0
          JSON.parse(response.body)
        else
          nil
        end
      end
    end
  end
end
