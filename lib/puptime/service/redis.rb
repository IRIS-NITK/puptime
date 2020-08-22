# frozen_string_literal: true

require "redis"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class Redis < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :ip_addr, :port, :db, :password

      def initialize(name, id, type, interval, options = {})
        super
        validate_params(options)
        @ip_addr, @port, @db, @password = parse_redis_params(options)
      end

      def resource_name
        @ip_addr + ":" + @port.to_s + "/" + @db.to_s
      end

      def run
        @scheduler.every @interval, overlap: false, job: true do
          ping
        end
      end

    private

      def validate_params(options)
        raise ParamMissingError, @name unless (options["ip_addr"]) && options["port"] && options["db"]
      end

      def parse_redis_params(options)
        return options["ip_addr"], options["port"].to_i, options["db"].to_i, options["password"]
      end

      def _ping
        begin
          redis = ::Redis.new(host: @ip_addr, port: @port, db: @db, password: @password, timeout: 1)
          redis.ping
          true
        rescue StandardError
          false
        end
      end
    end
  end
end
