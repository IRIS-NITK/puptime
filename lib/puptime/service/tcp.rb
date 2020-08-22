# frozen_string_literal: true

require "net/ping/tcp"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class TCP < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :port, :ip_addr

      def initialize(name, id, type, interval, options = {})
        super
        raise ParamMissingError, @name unless options["port"] && options["ip_addr"]

        @ip_addr, @port = parse_tcp_params(options)
      end

      def run
        @scheduler.every @interval, overlap: false, job: true do
          ping
        end
      end

      def resource_name
        @ip_addr + ":" + @port.to_s
      end
    private

      def save_tcp_record_to_db(message)
        persistence_service = Puptime::Persistence::Service.find_by(name: @name)
        persistence_service.services_tcp.create(message: message) if persistence_service
      end

      def parse_tcp_params(options)
        Puptime::Service::Base.validate_ip_addr(options["ip_addr"])
        return options["ip_addr"], options["port"]
      end

      def _ping
        Net::Ping::TCP.new(@ip_addr, @port).ping?
      end
    end
  end
end
