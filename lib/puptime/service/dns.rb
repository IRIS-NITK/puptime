# frozen_string_literal: true

require "resolv"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class DNS < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :dns_service

      RECORD_TYPES = { 'A': Resolv::DNS::Resource::IN::A, 'AAAA': Resolv::DNS::Resource::IN::AAAA,
                       'MX': Resolv::DNS::Resource::IN::MX, 'CNAME': Resolv::DNS::Resource::IN::CNAME,
                       'NS': Resolv::DNS::Resource::IN::NS }

      DNSService = Struct.new(:resource, :record_type, :results, :match) do
        def resource_name
          if match
            resource + "#" + record_type.to_s + " ==> " + results
          else
            resource + "#" + record_type.to_s + "exists"
          end
        end
      end

      def initialize(name, id, type, interval, options = {})
        super
        validate_params(options)
        @dns_service = parse_dns_params(options)
      end

      def ping_by_record_type
        case @dns_service.record_type
        when :A
          a_ping(@dns_service.resource)
        when :AAAA
          aaaa_ping(@dns_service.resource)
        when :MX
          mx_ping(@dns_service.resource)
        when :NS
          ns_ping(@dns_service.resource)
        when :CNAME
          cname_ping(@dns_service.resource)
        else
          raise ArgumentError, "Undefined DNS Record Type"
        end
      end

      def self.ping
        if _ping
          info service_name: @dns_service.resource_name
        else
          error service_name: @dns_service.resource_name
          Puptime::Service::Base.notifier_base(@dns_service.resource_name)
        end
      end

    private

      def save_dns_record_to_db(message)
        return
        persistence_service = Puptime::Persistence::Service.find_by(name: @name)
        persistence_service.services_dns.create(message: message) if persistence_service
      end

      def validate_params(options)
        raise ParamMissingError, @name unless (options["resource"]) && options["record_type"] && options["results"]
        raise ValidationError, @name unless options["record_type"].to_sym
      end

      def parse_dns_params(options)
        results = options["results"].split(",").map(&:strip)
        match = %w[true 1].include? options["match"]
        DNSService.new(options["resource"], options["record_type"].to_sym, results, match)
      end

      def mx_ping(resource)
        Resolv::DNS.new.getresources(resource, RECORD_TYPES[:MX]).map {|r| r.exchange.to_s }
      end

      def a_ping(resource)
        Resolv::DNS.new.getresources(resource, RECORD_TYPES[:A]).map {|r| r.address.to_s }
      end

      def aaaa_ping(resource)
        Resolv::DNS.new.getresources(resource, RECORD_TYPES[:AAAA]).map {|r| r.address.to_s }
      end

      def ns_ping(resource)
        Resolv::DNS.new.getresources(resource, RECORD_TYPES[:NS]).map {|r| r.name.to_s }
      end

      def cname_ping(resource)
        Resolv::DNS.new.getresources(resource, RECORD_TYPES[:CNAME]).map {|r| r.name.to_s }
      end

      def _ping
        if @dns_service.match
          ping_by_record_type.any?
        else
          ping_result = ping_by_record_type
          ping_result.sort == @dns_service.results.sort
        end
      end
    end
  end
end
