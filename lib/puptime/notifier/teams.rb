# frozen_string_literal: true

module Puptime
  class Notifier
    # Email notifier
    class Teams < Puptime::Notifier::Base
      include Puptime::Logging

      def initialize(message, configuration)
        @api_key = configuration["api_key"]
        super(message)
      end

      def send
        log.info "Sending teams to #{@message}"
      end
    end
  end
end
