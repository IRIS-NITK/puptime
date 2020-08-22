# frozen_string_literal: true

require "typhoeus"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class HTTP < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :url, :request_method, :response_code, :headers, :options

      def initialize(name, id, type, interval, options = {})
        super
        raise ParamMissingError, @name unless options["url"] && options["request-method"]

        @url, @request_method, @response_code, @headers, @options = parse_http_params(options)
      end

      def resource_name
        @request_method.to_s.upcase + " " + @url
      end

      def run
        @scheduler.every @interval, overlap: false, job: true do
          ping
        end
      end

      def ping
        _ping ? :success : :failure
      end

    private

      def build_request
        Typhoeus::Request.new(@url, build_request_options)
      end

      def _ping
        request = build_request
        response = request.run
        validate_response(response)
      end

      def build_request_options
        options = {}
        options[:method] = @request_method
        options[:body] = @options["body"] if @options["body"]
        options[:params] = @options["params"] if @options["params"]
        options[:headers] = @options["headers"] if @options["headers"]
        options[:username] = @options["username"] if @options["username"]
        options[:password] = @options["password"] if @options["password"]
        options[:followlocation] = true if @options["follow-redirect"]
        options[:timeout] = 5
        options
      end

      def validate_response(response)
        return unless validate_code(response)

        if @options["has-text"]
          validate_text(response)
          return
        end

        log.info "ping successful to #{resource_name}"
      end

      def validate_code(response)
        return true if response.response_code == @code

        raise_error_level
        log.info "ping failed to #{resource_name}"
        false
      end

      def validate_text(response)
        if response.response_body.include? @options["has-text"]
          log.info "ping successful to #{resource_name} with text match"
        else
          raise_error_level
          log.info "ping successful to #{resource_name} NO text match"
        end
      end

      def parse_http_params(options)
        Puptime::Service::Base.validate_url(options["url"])
        return options["url"], options["request-method"].downcase.to_sym, options["response-code"], options["headers"], options.slice("follow-redirect", "has-text", "params", "body", "username", "password")
      end
    end
  end
end
