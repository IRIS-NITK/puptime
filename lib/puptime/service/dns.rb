# frozen_string_literal: true

require "resolv"

module Puptime
  #:no_doc:
  class Service
    # TCP service
    class DNS < Puptime::Service::Base
      include Puptime::Logging
      attr_reader :record_type, :resource, :results, :match

      RECORD_TYPES = { 'A': Resolv::DNS::Resource::IN::A, 'AAAA': Resolv::DNS::Resource::IN::AAAA,
                       'MX': Resolv::DNS::Resource::IN::MX, 'CNAME': Resolv::DNS::Resource::IN::CNAME,
                       'NS': Resolv::DNS::Resource::IN::NS }

      def initialize(name, id, type, interval, options = {})
        super
        validate_params(options)
        @resource, @record_type, @results, @match = parse_dns_params(options)
      end

      def resource_name
        if @match
          @resource + "#" + @record_type.to_s + " ==> " + @results.to_s
        else
          @resource + "#" + @record_type.to_s + "exists"
        end
      end

      def run
        @scheduler.every @interval, overlap: false, job: true do
          ping
        end
      end

      def ping_by_record_type
        case @record_type
        when :A
          a_ping(@resource)
        when :AAAA
          aaaa_ping(@resource)
        when :MX
          mx_ping(@resource)
        when :NS
          ns_ping(@resource)
        when :CNAME
          cname_ping(@resource)
        else
          raise ArgumentError, "Undefined DNS Record Type"
        end
      end

    private

      def save_dns_record_to_db(message)
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
        return options["resource"], options["record_type"].to_sym, results, match
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
        if @match
          ping_result = ping_by_record_type
          ping_result.sort == @results.sort
        else
          ping_by_record_type.any?
        end
      end
    end
  end
end
