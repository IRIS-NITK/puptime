# frozen_string_literal: true

require "net/ping/icmp"

module Puptime
  #:no_doc:
  class Service
    # UDP service
    class UDP < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :udp_service

      UDPService = Struct.new(:ip_addr, :port, :command, :timeout) do
        def resource_name
          "udp://#{ip_addr}:#{port}"
        end
      end

      def initialize(name, id, type, interval, options = {})
        super
        raise ParamMissingError, @name unless options["ip_addr"] && options["port"]

        @udp_service = build_udp_service(options)
      end

      def run
        @scheduler_job_id = @scheduler.every @interval, overlap: false, job: true do
          ping
        end
      end

      def ping
        udp_ping = Net::Ping::ICMP.new(@udp_service.ip_addr, @udp_service.port, @udp_service.timeout)
        udp_ping.data = @udp_service.command

        if udp_ping.ping?
          log.info "Ping to #{@udp_service.resource_name} successful"
        else
          raise_error_level
          log.info "Ping to #{@udp_service.resource_name} failed"
        end
      end

      private

        def build_udp_service(options)
          UDPService.new(
            options["ip_addr"],
            options["port"],
            options["command"] || 'ping',
            options["timeout"] || 5
          )
        end
    end
  end
end
