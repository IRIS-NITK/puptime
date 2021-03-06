# frozen_string_literal: true

require "typhoeus"
require "puptime/notification_queue"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class HTTP < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :http_service

      HTTPService = Struct.new(:url, :method, :code, :headers, :options) do
        def resource_name
          method.to_s.upcase + " " + url
        end
      end

      def initialize(name, id, type, interval, options = {})
        super
        raise ParamMissingError, @name unless options["url"] && options["request-method"]

        @http_service = parse_http_params(options)
      end

      def run
        @scheduler_job_id = @scheduler.every @interval, overlap: false, job: true do
          success, status_code = ping
          status_code = "NO RESPONSE" if status_code == 0
          unless success
            Puptime::NotificationQueue.enqueue_notification(@http_service.resource_name + " " + status_code.to_s)
          end
        end
      end

      def ping
        request = build_request(@http_service)
        response = request.run
        return validate_response(response), response.response_code
      end

    private

      def build_request(http_service)
        Typhoeus::Request.new(http_service.url, build_request_options(http_service))
      end

      def build_request_options(http_service)
        options = {}
        options[:method] = http_service.method
        options[:body] = http_service.options["body"] if http_service.options["body"]
        options[:params] = http_service.options["params"] if http_service.options["params"]
        options[:headers] = http_service.options["headers"] if http_service.options["headers"]
        options[:username] = http_service.options["username"] if http_service.options["username"]
        options[:password] = http_service.options["password"] if http_service.options["password"]
        options[:followlocation] = true if http_service.options["follow-redirect"]
        options[:timeout] = 5
        options
      end

      def validate_response(response)
        return unless validate_code(response)

        if @http_service.options["has-text"]
          validate_text(response)
          return
        end

        info service_name: @http_service.resource_name, service_message: "Ping Successful"
      end

      def validate_code(response)
        return true if response.response_code == @http_service.code

        raise_error_level
        error service_name: @http_service.resource_name, service_message: "Ping Failed " + response.response_code.to_s
        false
      end

      def validate_text(response)
        if response.response_body.include? @http_service.options["has-text"]
          info service_name: @http_service.resource_name, service_message: "Text match Successful"
        else
          raise_error_level
          warn service_name: @http_service.resource_name, service_message: "Text match Failed"
        end
      end

      def parse_http_params(options)
        Puptime::Service::Base.validate_url(options["url"])
        HTTPService.new(options["url"], options["request-method"].downcase.to_sym, options["response-code"], options["headers"], options.slice("follow-redirect", "has-text", "params", "body", "username", "password"))
      end
    end
  end
end
