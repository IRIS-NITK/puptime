# frozen_string_literal: true

module Puptime
  class Service
    # Base class
    class Base
      ERROR_LEVEL = { 0 => "Normal", 1 => "Warning", 2 => "Severe", 3 => "Boom Boom Ciao" }
      attr_reader :name, :group, :interval, :scheduler
      attr_accessor :scheduler_job

      IP_REGEX = /(?:(?-mix:\A((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))\.((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))\.((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))\.((?x-mi:0
               |1(?:[0-9][0-9]?)?
               |2(?:[0-4][0-9]?|5[0-5]?|[6-9])?
               |[3-9][0-9]?))\z))|(?:(?x-mi:
      (?:(?x-mi:\A
      (?:[0-9A-Fa-f]{1,4}:){7}
         [0-9A-Fa-f]{1,4}
      \z)) |
      (?:(?x-mi:\A
      ((?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?) ::
      ((?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?)
      \z)) |
      (?:(?x-mi:\A
      ((?:[0-9A-Fa-f]{1,4}:){6,6})
      (\d+)\.(\d+)\.(\d+)\.(\d+)
      \z)) |
      (?:(?x-mi:\A
      ((?:[0-9A-Fa-f]{1,4}(?::[0-9A-Fa-f]{1,4})*)?) ::
      ((?:[0-9A-Fa-f]{1,4}:)*)
      (\d+)\.(\d+)\.(\d+)\.(\d+)
      \z))))/.freeze

      URL_REGEX = %r{^(http://www\.|https://www\.|http://|https://)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$}ix.freeze

      def initialize(name, group, type, interval, options = {})
        @name = name
        @group = options[:group] || nil
        @type = type
        @interval = interval
        @scheduler_job = nil
        @scheduler = Rufus::Scheduler.singleton
        @error_level = 0
        save_service_to_db
      end

      def raise_error_level
        @error_level += 1 if @error_level < 3
      end

      def self.validate_ip_addr(ip_addr)
        raise ValidationError, "IP Address format invalid #{@name}" unless (Puptime::Service::Base::IP_REGEX.match? ip_addr) || (ip_addr == "localhost")
      end

      def self.validate_url(url)
        raise ValidationError, "URL invalid #{@name}" unless Puptime::Service::Base::URL_REGEX.match? url
      end

    private

      def save_service_to_db
        return
        # TODO: Fix persistence
        Puptime::Persistence::Service.create(name: @name, group: @group,
                                             service_type: @type, interval: @interval)
      end
    end
  end
end
