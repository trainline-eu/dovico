require 'typhoeus'
require 'json'
require 'uri'
require 'cgi'

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

      def get_paginated_list(path, object_key, **params)
        results = get(path, **params)
        objects = results[object_key]

        loop do
          next_page_uri = results["NextPageURI"]
          break if next_page_uri.nil? || next_page_uri == "N/A"

          results = get(next_page_uri)
          objects += results[object_key]
        end

        { object_key => objects }
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
        # Do not append URL if it's already passed in the path
        uri = URI(path)
        if uri.host.nil?
          uri = URI(API_URL).merge(path)
        end

        # Merge query parameters to prevent duplicate
        if uri.query.present?
          params_hash = CGI.parse(uri.query).map {|k,v| [k, v.first] }.to_h.symbolize_keys

          params.merge!(params_hash)
          uri.query = nil
        end

        request = Typhoeus::Request.new(
          uri.to_s,
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
