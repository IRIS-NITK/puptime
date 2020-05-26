# frozen_string_literal: true

require "set"
module Puptime
  #:no_doc:
  class ServiceSet
    attr_reader :services

    AVAILABLE_SERVICES = %w[TCP DNS Redis]
    MANDATORY_KEYS = %w[name type interval options]

    # Raised if service isn't available
    class ServiceNotAvailable < StandardError
      def initialize(msg)
        super("Service defined in config not currently available: #{msg}")
      end
    end

    # Raised if service required params not available
    class MissingParams < StandardError
      def initialize(msg)
        super("Service defined in config doesn't have required params: #{msg}")
      end
    end

    def initialize(config)
      @services = servicify(config)
      Rufus::Scheduler.singleton(max_work_threads: 30)
    end

    def run
      @services.each(&:run)
    end

  private

    def servicify(monitors)
      services = Set.new
      monitors.each do |service|
        services.add parse_service_config(service)
      end
      services
    end

    def parse_service_config(data)
      if mandatory_params_present?(data)
        if AVAILABLE_SERVICES.include? data["type"]
          service_object(data)
        else
          raise ServiceNotAvailable, data["type"]
        end
      else
        raise MissingParams, data
      end
    end

    def mandatory_params_present?(params)
      MANDATORY_KEYS.all? {|k| params.key? k }
    end

    def service_object(data)
      Puptime::Service.const_get(data["type"]).new(data["name"], data["id"], data["type"], data["interval"], data["options"])
    end
  end
end
