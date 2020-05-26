# frozen_string_literal: true

require "mail"

module Puptime
  class Notifier
    # Email notifier
    class Email < Puptime::Notifier::Base
      include Puptime::Logging

      def initialize(message, configuration)
        @to = configuration["to"]
        @from = configuration["from"]
        @delivery_method = configuration["delivery_method"] || "smtp"
        @address = configuration["address"]
        @port = configuration["port"]
        @username = configuration["username"]
        @password = configuration["password"]
        @authentication = configuration["authentication"] || "plain"
        @start_ttls_auto = configuration["enable_starttls_auto"] || true
        super(message)
      end

      def send
        log.info "Sending email to #{@to}"
      end
    end
  end
end
