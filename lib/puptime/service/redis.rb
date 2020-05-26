# frozen_string_literal: true

require "redis"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class Redis < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :redis_service

      RedisService = Struct.new(:ip_addr, :port, :db, :password) do
        def resource_name
          ip_addr + ":" + port.to_s + "/" + db.to_s
        end
      end

      def initialize(name, id, type, interval, options = {})
        super
        validate_params(options)
        @redis_service = parse_redis_params(options)
      end

      def run
        @scheduler_job_id = @scheduler.every @interval, overlap: false, job: true do
          ping(@redis_service)
        end
      end

      def ping(redis_service)
        if _ping
          ping_success_callbacks("pinging #{redis_service.resource_name} at #{Time.now} successful")
        else
          raise_error_level
          ping_failure_callbacks("pinging #{redis_service.resource_name} at #{Time.now} failed")
        end
      end

    private

      def ping_success_callbacks(message)
        log.info message
      end

      def ping_failure_callbacks(message)
        log.info message
      end

      def validate_params(options)
        raise ParamMissingError, @name unless (options["ip_addr"]) && options["port"] && options["db"]
      end

      def parse_redis_params(options)
        RedisService.new(options["ip_addr"], options["port"].to_i, options["db"].to_i, options["password"])
      end

      def _ping
        begin
          redis = ::Redis.new(host: @redis_service.ip_addr, port: @redis_service.port, db: @redis_service.db, password: @redis_service.password, timeout: 1)
          redis.ping
          true
        rescue StandardError
          false
        end
      end
    end
  end
end
