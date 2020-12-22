# frozen_string_literal: true

require "net/ping/tcp"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class TCP < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :tcp_service

      TCPService = Struct.new(:ip_addr, :port) do
        def address
          ip_addr + ":" + port.to_s
        end
      end

      def initialize(name, id, type, interval, options = {})
        super
        raise ParamMissingError, @name unless options["port"] && options["ip_addr"]

        @tcp_service = parse_tcp_params(options)
      end

      def run
        @scheduler_job_id = @scheduler.every @interval, overlap: false, job: true do
          ping
        end
      end

      def ping
        if Net::Ping::TCP.new(@tcp_service.ip_addr, @tcp_service.port).ping?
          info service_name: @tcp_service.address
        else
          raise_error_level
          Puptime::NotificationQueue.enqueue_notification(@tcp_service.address)
          error service_name: @tcp_service.address
        end
      end

    private
      def save_tcp_record_to_db(message)
        return
        # TODO: Fix persistence
        persistence_service = Puptime::Persistence::Service.find_by(name: @name)
        persistence_service.services_tcp.create(message: message) if persistence_service
      end

      def parse_tcp_params(options)
        Puptime::Service::Base.validate_ip_addr(options["ip_addr"])
        TCPService.new(options["ip_addr"], options["port"])
      end
    end
  end
end
